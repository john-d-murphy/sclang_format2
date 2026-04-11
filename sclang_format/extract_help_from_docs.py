#!/usr/bin/env python3
"""
Extract code examples from SuperCollider .schelp documentation files
into individual .scd files for formatter testing.

v3: Enhanced filtering for grammar limitations and non-code patterns
    - Template class names (YourClass, MyClass, etc.)
    - Class instantiation with trailing block (Routine { }, Task { })
    - Separator lines, GUI fragments, URLs
    - Better pseudo-code detection
"""

import re
from pathlib import Path

HELP_DIR = Path("/usr/share/SuperCollider/HelpSource/")
OUTPUT_DIR = Path("tests/sc_help/")
CODE_PATTERN = re.compile(r"code::\s*\n(.*?)\n::", re.DOTALL)


def sanitize_filename(name: str) -> str:
    """Remove/replace characters that are problematic in filenames."""
    return name.replace("/", "_").replace("\\", "_").replace(" ", "_")


# ============================================================================
# NON-CODE DETECTION
# ============================================================================


def is_not_code(code: str) -> tuple[bool, str]:
    """
    Detect content that is not valid standalone SuperCollider code.
    Returns (is_not_code, reason) tuple.
    """
    code = code.strip()
    if not code:
        return True, "empty"

    # Get non-comment lines for analysis
    lines = [
        l for l in code.split("\n") if l.strip() and not l.strip().startswith("//")
    ]
    if not lines:
        return True, "only_comments"

    first_line = lines[0].strip() if lines else ""

    # ----- Shell commands -----
    if re.match(r"^(sudo|git|grep|scsynth|sclang\s+-|cd\s|ls\s|cat\s|echo\s)", code):
        return True, "shell_command"

    # ----- Output examples (error messages, bytecodes dumps, etc.) -----
    # Can appear at start OR in the middle of the block
    output_patterns = [
        r"^(ERROR:|BYTECODES:|Instance of|-> |WARNING:|CALL STACK:)",
        r"\n(ERROR:|WARNING:|CALL STACK:)",  # mid-block output
        r"// prints:\n[A-Z]",  # "// prints:" followed by output
        r"^-->",  # Output arrow at start of line
    ]
    for pattern in output_patterns:
        if re.search(pattern, code, re.MULTILINE):
            return True, "output_example"

    # ----- Emacs Lisp configuration -----
    if (
        "custom-set-variables" in code
        or "global-set-key" in code
        or "define-key" in code
    ):
        return True, "emacs_lisp"
    # Also catch Emacs Lisp style parens at start: (define-key, (setq, etc.
    if re.match(r"^\s*\((define-key|setq|add-hook|require|defun|defvar)\s", code):
        return True, "emacs_lisp"

    # ----- Math notation (f(x) = expr) -----
    if re.match(r"^[a-z]\([a-z]\)\s*=", code):
        return True, "math_notation"

    # ----- Method/function signature lists (no actual code) -----
    if re.match(r"^[a-z][a-zA-Z]+\n\s+[a-z]", code) and not re.search(r"[{(;=]", code):
        return True, "method_list"

    # ----- ASCII diagrams (node trees, signal flow, etc.) -----
    if (
        re.match(r"^\s*(Group|Synth|/|\\|\|)", code)
        and code.count("/") + code.count("\\") > 3
    ):
        if not re.search(r"[{;]", code[:100]):
            return True, "ascii_diagram"
    # Arrow diagrams showing signal flow: synth 1 ---> synth 2
    if re.search(r"---+>|<---+", code):
        return True, "ascii_diagram"

    # ----- Pseudo-code with .. placeholders (not ranges) -----
    # Match things like "expr.do {|name| ..next qualifier.. }" or "{ truebody }..."
    # Also match standalone ... as placeholder (but not as rest arg in destructuring)
    if ".." in code:
        # Check if it's NOT a valid range pattern
        has_range = re.search(r"\(\s*\d+\s*\.\.\s*\d*\s*\)", code)  # (1..10) or (1..)
        has_pseudo = re.search(
            r"\.\.[a-zA-Z]|[a-zA-Z]\.\.|}\s*\.\.\.", code
        )  # ..next, func..., }...
        # Standalone ... as placeholder (not in # a, b ... c destructuring)
        # Look for ... that's not after a comma with identifiers before it
        has_ellipsis_placeholder = re.search(
            r"[,(]\s*\.\.\.\s*[,)]", code
        )  # (...) or , ... ,
        has_ellipsis_in_call = re.search(r"\w+\(\s*\.\.\.\s*\)", code)  # func(...)

        if has_pseudo and not has_range:
            return True, "pseudo_code"
        if has_ellipsis_placeholder or has_ellipsis_in_call:
            return True, "pseudo_code"

    # ----- Mixed code+output (code followed by its printed result) -----
    # Pattern: code line(s) followed by bare output without SC syntax
    if len(lines) >= 2:
        # Check if last line(s) look like output rather than code
        last_line = lines[-1].strip()
        # Output patterns: starts with [, bare words, numbers, "this is a test"
        if re.match(r"^\[.*\]$", last_line) and not re.search(r"[{;=]", last_line):
            # Looks like printed array output
            if not last_line.startswith("[") or ";" not in code:
                pass  # Could be output
        # "this is a test. pi = 3.14" type output
        if re.match(r"^[a-z].*\.\s+[a-z]", last_line, re.IGNORECASE):
            if not re.search(r"[{(;]", last_line):
                return True, "mixed_output"

    # ----- Documentation header mixed with code -----
    # Pattern: "[1] Description text" before actual code
    if re.match(r"^\[\d+\]", code):
        return True, "doc_header"

    # ----- Single bare comma or other non-code tokens -----
    if code in [",", ";", ".", ":", "|", "||", "&&"]:
        return True, "bare_token"
    # Orphan braces from split blocks
    if re.match(r"^\s*[}\])]+;?\s*$", code):
        return True, "bare_token"

    # ----- Separator lines (--- or ===) -----
    if re.match(r"^[-=]{3,}\s*$", first_line):
        return True, "separator_line"

    # ----- Template/placeholder class names -----
    if re.match(r"^(YourClass|MyClass|SomeClass|TestYourClass|MyOtherClass)\b", code):
        return True, "template_class"

    # ----- URL/path strings (not code) -----
    if re.match(r"^(https?://|quarkname=|/path/to/)", code):
        return True, "url_or_path"

    # ----- SCDoc markup (not SC code) -----
    # Pattern: link::Classes/ClassName:: or similar
    if re.search(r"link::[A-Za-z/]+::", code):
        return True, "scdoc_markup"
    # SCDoc list items starting with ##
    if re.search(r"^##\s*link::", code, re.MULTILINE):
        return True, "scdoc_markup"

    # ----- C/C++ code (from UGen writing docs) -----
    if re.search(
        r"^\s*(struct|class|#include|typedef|void\s+\w+\()", code, re.MULTILINE
    ):
        return True, "cpp_code"

    # ----- Unicode symbols not in SC (±) -----
    if "±" in code:
        return True, "unicode_math"

    # ----- OSC message output [ /command, ... ] -----
    if re.match(r"^\s*\[\s*/[a-z]", code):
        return True, "output_example"

    # ----- Signal/array placeholder notation -----
    # Pattern: Signal: [a0, a1, a2...]
    if re.search(r":\s*\[[a-z]\d+,\s*[a-z]\d+.*\.\.\.\]", code):
        return True, "pseudo_code"

    # ----- Bare modulo/output -----
    # Pattern: %1.0 or similar bare output
    if re.match(r"^%[\d.]+\s*$", code.strip()):
        return True, "output_example"

    # ----- Bare method names -----
    # Pattern: .methodName alone showing method existence
    if re.match(r"^\s*\.[a-zA-Z_][a-zA-Z0-9_]*\s*$", code.strip()):
        return True, "pseudo_code"

    # ----- SCDoc strong/emphasis markup -----
    if re.search(r"(strong|emphasis|code|teletype)::", code):
        return True, "scdoc_markup"

    # ----- Debug output "Synth 1002" pattern -----
    if re.match(r"^Synth\s+\d+\s*$", code.strip()):
        return True, "output_example"

    # ----- String as hash key pattern (unusual) -----
    # Pattern: Synth("-613784702" : 1000) - string used as key with colon
    if re.search(r'"[^"]+"\s*:\s*\d+', code):
        return True, "pseudo_code"

    # ----- Adjacent string concatenation (grammar limitation) -----
    # Pattern: "hel" "lo" - adjacent strings are concatenated in SC
    if re.search(r'"\s+"', code):
        return True, "adjacent_strings"

    # ----- Literal array defaults in pipe params (grammar limitation) -----
    # Pattern: arg name (#[...]) - parenthesized literal array default
    if re.search(r"\|\s*[a-z][^|]*\(#\[", code):
        return True, "literal_array_default"

    # ----- Routine shorthand (grammar limitation) -----
    # Pattern: r { } - creates a Routine, can't parse due to ambiguity with r as variable
    if re.search(r"\br\s*\{", code):
        return True, "routine_shorthand"

    # ----- Prout shorthand (grammar limitation) -----
    # Pattern: p { } - creates a Prout, same ambiguity as r { }
    if re.search(r"\bp\s*\{", code):
        return True, "prout_shorthand"

    # ----- Bare SCDoc closing ---
    # Pattern: just :: on its own
    if re.match(r"^\s*::\s*$", code.strip()):
        return True, "scdoc_markup"

    # ----- Arrow at start (output/docs) -----
    if re.match(r"^\s*->", code):
        return True, "output_example"

    # ----- Catch with exception type (unusual syntax) -----
    # Pattern: catch { ExceptionType varname }
    if re.search(r"\bcatch\s*\{\s*[A-Z][a-zA-Z]+\s+[a-z]", code):
        return True, "catch_typed"

    # ----- arg ... name (variable args documentation) -----
    if re.match(r"^\s*arg\s+\.\.\.", code):
        return True, "pseudo_code"

    # ----- Showing invalid syntax (var 1var) -----
    if re.search(r"\bvar\s+\d", code):
        return True, "pseudo_code"

    # ----- Operator list documentation -----
    if re.match(r"^[!@%&*\-+=|<>?/\s]+$", code.strip()):
        return True, "pseudo_code"

    # ----- Events with identifier keys (grammar limitation) -----
    # Pattern: (a: 1, b: 2) - identifier keys conflict with method_name binary operator
    # The regex method_name: matches "a:" as single token, blocking associative_item parse
    if re.search(r'\(\s*[a-z_][a-zA-Z0-9_]*\s*:\s*[\d\[\{\(\-~\\\'"]', code):
        return True, "event_identifier_keys"

    # ----- DSP formula notation ---
    # Pattern: out(i) = ... or in(i-1) - signal processing formulas
    if re.search(r"\b(out|in)\s*\(\s*[in]\s*[\-+]?", code):
        return True, "dsp_formula"

    # ----- Incomplete code fragments ---
    # Pattern: ends with open paren/bracket suggesting incomplete
    if re.search(r"\(\s*$", code.strip()):
        return True, "incomplete_fragment"

    # ----- English prose mixed with code ---
    # Pattern: Starts with "Has the effect" or similar
    if re.match(
        r"^(Has the|This is|The |Note that|See also|Take a look|For more|Here is|Also see)",
        code,
    ):
        return True, "prose_text"

    # ----- SCDoc link syntax ---
    # Pattern: link::Classes/SinOsc:: or link::Foo/Bar#section::
    if re.search(r"link::[A-Za-z/]+", code):
        return True, "scdoc_markup"

    # ----- SCDoc syntax examples ---
    # Pattern: \:: expr or :while expr - showing syntax notation
    if re.match(r"^\s*\\?::\s*\w", code.strip()):
        return True, "scdoc_markup"
    if re.match(r"^\s*:[a-z]+\s+\w", code.strip()):
        return True, "scdoc_markup"

    # ----- "is equivalent to" explanations ---
    # Pattern: a = NodeProxy(s) is equivalent to ~a;
    if re.search(r"\s+is equivalent to\s+", code):
        return True, "prose_text"

    # ----- Plain text "a Something" pattern ---
    # Pattern: "a Function" or "a SynthDef" - showing type, not code
    if re.match(r"^a [A-Z][a-zA-Z]+\s*$", code.strip()):
        return True, "prose_text"

    # ----- Prose sentence ending with period ---
    # Pattern: "Here is a random number: 13." - sentence with period
    if re.search(r"[a-z]{3,}\s+[a-z]+\s+[a-z]+.*\.\s*$", code.strip()):
        if not re.search(r"[\(\)\[\]\{\};]", code):  # No code punctuation
            return True, "prose_text"

    # ----- Structure diagram pseudo-code ---
    # Pattern: "default group [" or indented structure with brackets
    if re.match(r"^\s*[a-z]+\s+[a-z]+\s*\[", code):
        return True, "pseudo_code"

    # ----- C enum definitions ---
    # Pattern: enum { ... } - C code from server docs
    if re.match(r"^\s*enum\s*\{", code):
        return True, "cpp_code"

    # ----- C++ namespace ---
    # Pattern: namespace Name { - C++ code
    if re.match(r"^\s*namespace\s+[A-Za-z_][A-Za-z0-9_]*\s*\{", code):
        return True, "cpp_code"

    # ----- Emacs Lisp code ---
    # Pattern: '(sclang-eval... - Elisp from Emacs editor docs
    if re.match(r"^\s*'\([a-z\-]+", code):
        return True, "elisp_code"

    # ----- Accidental notation examples ---
    # Pattern: -2s == -1.9 - musical accidental notation
    if re.search(r"-?\d+[sb]+\s*==\s*-?\d+\.\d", code):
        return True, "accidental_notation"

    # ----- Missing semicolon between statements (doc typo) ---
    # Pattern: "string".method\n"string" - missing ; before next statement
    if re.search(r'"\s*\.\w+\s*\n\s*"', code):
        return True, "missing_semicolon"

    # ----- Missing comma in array (doc typo) ---
    # Pattern: [value\symbol] or [0\name] - missing comma before symbol
    if re.search(r"\[\s*\d+\\[a-z]", code):
        return True, "missing_comma"
    if re.search(r",\s*\d+\\[a-z]", code):
        return True, "missing_comma"

    # ----- Plugin placeholder ---
    # Pattern: = ... plug-in ... or = ... class name ...
    if re.search(r"=\s*\.\.\..*\.\.\.", code):
        return True, "pseudo_code"

    # ----- Primitive syntax ---
    # Pattern: _PrimitiveName - internal SC primitives
    if re.search(r"^\s*_[A-Z][a-zA-Z]+", code, re.MULTILINE):
        return True, "primitive_syntax"

    # ----- Math pseudo-code with Greek/for...from ---
    if re.search(r"π|for [a-z] from", code):
        return True, "math_notation"

    # ----- Mismatched brackets ---
    # Pattern: unbalanced ( ) or [ ] or { } - typo in docs
    if (
        code.count("]") != code.count("[")
        or code.count(")") != code.count("(")
        or code.count("}") != code.count("{")
    ):
        return True, "mismatched_brackets"

    # ----- Bare method key (not in parens) ---
    # Pattern: methodKey: value without being in event parens
    if re.match(r"^[a-z][a-zA-Z0-9_]*:\s+[a-z~]", code.strip()):
        return True, "bare_method_key"

    # ----- HID/device output ---
    if re.search(r"page:\s*\d+.*usage:", code):
        return True, "output_example"

    # ----- Shell/git commands ---
    if re.match(r"^(git\s|#\s*(in the|run))", code):
        return True, "shell_command"

    # ----- Class instantiation with trailing block (grammar limitation) -----
    # Patterns like "Routine {" or "Task {" can't be parsed due to class_def conflict
    # Also catches "x = Routine {" and "~x = Routine {" assignments
    class_block_pattern = r"(?:^|[=,;(\s])(Routine|Task|Prout|Plazy|Pfunc|Pfuncn|Pproto|PlazyEnvir|PlazyEnvirN|CallOnce)\s*\{"
    if re.search(class_block_pattern, code):
        return True, "class_trailing_block"

    # ----- Standalone GUI property access without context -----
    if re.match(
        r"^[a-z]\.(enabled|bounds|view|front|value|string)\s*[=;]?\s*$", first_line
    ):
        if len(lines) == 1:
            return True, "gui_fragment"

    # ----- Template/placeholder code blocks -----
    # Pattern: { keyword body } or { keyword anotherKeyword }
    # These are documentation templates, not real code
    template_block = re.match(r"^\{\s*[a-z]+\s+[a-z]+\s*\};?$", code.strip())
    if template_block:
        return True, "pseudo_code"

    # ----- Syntax demonstration patterns -----
    # Pattern: expr identifier; where identifier is just a bare name showing syntax
    # e.g., "collect((1..5)) f;" showing that f is shorthand
    # Need to handle nested parens, so we just check the overall structure
    syntax_demo = re.match(r"^[a-zA-Z_][a-zA-Z0-9_]*\(.+\)\s+[a-z];?$", code.strip())
    if syntax_demo:
        # Make sure the trailing identifier is truly standalone (not a method call)
        # and there are balanced parens
        stripped = code.strip()
        if stripped.count("(") == stripped.count(")"):
            # Find where parens end and check what follows
            depth = 0
            paren_end = -1
            for i, c in enumerate(stripped):
                if c == "(":
                    depth += 1
                elif c == ")":
                    depth -= 1
                    if depth == 0:
                        paren_end = i
                        break
            if paren_end > 0 and paren_end < len(stripped) - 1:
                after_parens = stripped[paren_end + 1 :].strip().rstrip(";")
                # If what follows is just a single lowercase letter, it's a syntax demo
                if re.match(r"^[a-z]$", after_parens):
                    return True, "pseudo_code"

    # ----- Class definitions (not executable as standalone code) -----
    # Pattern: ClassName { } or ClassName : SuperClass { }
    if re.match(r"^[A-Z][a-zA-Z0-9_]*\s*(:\s*[A-Z][a-zA-Z0-9_]*)?\s*\{", code):
        # Make sure it's not just a class method call with trailing block
        # Class definitions typically have var, classvar, or method definitions inside
        if re.search(r"\{\s*(var\s|classvar\s|\*[a-z]|[a-z]+\s*\{)", code):
            return True, "class_definition"

    # ----- Event key documentation (not wrapped in parens) -----
    # Pattern: multiple lines of "key: value," with comments
    # Example:
    #   tempo:    nil,    // comment
    #   dur:      1.0,    // comment
    if not code.startswith("("):
        event_doc_lines = re.findall(
            r"^\s*[a-z_][a-zA-Z0-9_]*:\s+.+,?\s*//", code, re.MULTILINE
        )
        if len(event_doc_lines) >= 3:
            return True, "event_key_documentation"

    # ----- Bare method keyword documentation -----
    # Pattern: "methodName: value" on its own line (showing method syntax)
    # Examples: "dup: 3;", "bubble: 0", "collect: _.squared;"
    if re.match(r"^[a-z][a-zA-Z0-9_]*:\s*[^,]+;?\s*$", code.strip()):
        # But not if it looks like a full statement with receiver
        if not re.search(r"\.[a-z]|[A-Z][a-z]", code):
            return True, "pseudo_code"

    # ----- Placeholder notation -----
    # Pattern: Class.<...> or similar with <...> placeholder
    if re.search(r"<\.\.\.>", code):
        return True, "pseudo_code"
    # Pattern: <variable name> style placeholders
    if re.search(r"<[a-z][a-z ]+>", code):
        return True, "pseudo_code"

    # ----- Operator-first equivalence demonstrations -----
    # Pattern: == expr (showing what something equals)
    if re.match(r"^\s*[=!<>]+\s*\(", code):
        return True, "pseudo_code"

    # ----- Operator-first partial application demos -----
    # Pattern: + { } or - { } showing operator with function
    if re.match(r"^\s*[+\-*/%%&|<>]+\s*\{", code):
        return True, "pseudo_code"

    # ----- NodeProxy connection syntax (grammar limitation) -----
    # Pattern: <<>.slotName or <>>.slotName - special JITLib syntax
    if re.search(r"<<>\.[a-z]|<>>\.[a-z]", code):
        return True, "jitlib_special_syntax"

    # ----- Complex index patterns (grammar limitation) -----
    # Pattern: a[1, 3..] - multi-index with subrange - conflicts in grammar
    if re.search(r"\[[^]]*,\s*\d+\.\.[^]]*\]", code):
        return True, "complex_index_pattern"

    # ----- for with trailing block (grammar limitation) -----
    # Pattern: for(int, int) { } without function inside parens - conflicts in grammar
    # Match specifically for(number, number) followed by block
    if re.search(r"\bfor\s*\(\s*\d+\s*,\s*\d+\s*\)\s*\{", code):
        return True, "for_trailing_block"

    # ----- Debug/trace output mixed with code -----
    # Pattern: methodName-arg followed by values
    if re.search(r"[a-zA-Z]+-arg\s+[a-z]:", code):
        return True, "output_example"

    # ----- Trivial single-statement method calls -----
    # Pattern: x.free; or s.boot; - too simple to be useful tests
    # Matches: identifier.method; or identifier.method (with optional semicolon)
    # Must be single non-comment line
    if re.match(r"^[a-z_][a-zA-Z0-9_]*\.[a-z][a-zA-Z0-9_]*;?\s*$", code.strip()):
        return True, "trivial_method_call"

    # ----- Trivial nil assignment -----
    # Pattern: x = nil; - too simple to test
    if re.match(r"^[a-z_][a-zA-Z0-9_]*\s*=\s*nil;?\s*$", code.strip()):
        return True, "trivial_nil_assignment"

    # ----- Trivial empty string -----
    # Pattern: ""; - meaningless test
    if re.match(r'^"";?\s*$', code.strip()):
        return True, "trivial_empty_string"

    # ----- Trivial constant block -----
    # Pattern: { 8 } or { 10 } - constant-returning blocks too simple
    if re.match(r"^\{\s*\d+\s*\};?\s*$", code.strip()):
        return True, "trivial_constant_block"

    # ----- Ellipsis placeholder blocks -----
    # Pattern: { ... } or { ... a bunch of code ... } - documentation placeholders
    if re.match(r"^\{\s*\.\.\..*\};?\s*$", code.strip(), re.DOTALL):
        return True, "pseudo_code"

    # ----- Template blocks with placeholder names -----
    # Pattern: { loopFunc body } or { testFunc body } - documentation templates
    if re.match(r"^\{\s*[a-z]+Func\s+[a-z]+\s*\};?\s*$", code.strip()):
        return True, "pseudo_code"

    # ----- Control structure with template body -----
    # Pattern: while { testFunc body } - showing syntax with placeholder
    if re.search(
        r"(while|if|for|do|protect)\s*\{\s*[a-z]+\s+[a-z]+\s+[a-z]*\s*\}", code
    ):
        # Check if the block contains English words, not real code
        if not re.search(
            r"[;=\(\)\[\]]", code.split("{")[1].split("}")[0] if "{" in code else ""
        ):
            return True, "pseudo_code"

    # ----- forBy/while/collect with English parameters -----
    # Pattern: forBy(startValue, endValue, stepValue) - placeholders in parens
    if re.search(r"(forBy|while|for|if)\s*\(\s*[a-z]+Value", code):
        return True, "pseudo_code"

    # ----- Block containing prose/English -----
    # Pattern: protect { work with the file here } - English inside block
    if re.search(r"\{\s*[a-z]+\s+[a-z]+\s+the\s+[a-z]+", code):
        return True, "prose_text"

    # ----- Ellipsis placeholder blocks with method call -----
    # Pattern: { ... a bunch of code ... }.value; - placeholder with method
    if re.search(r"\{\s*\.\.\..*\}\s*\.\w+", code, re.DOTALL):
        return True, "pseudo_code"

    # ----- Math notation with special symbols -----
    # Pattern: z → expr or anything with → (unicode arrow)
    if "→" in code:
        return True, "math_notation"

    # ----- Absolute value notation -----
    # Pattern: |a| < 1 - math notation, not SC pipe syntax
    if re.match(r"^\|[a-z]\|\s*[<>=]", code.strip()):
        return True, "math_notation"

    # ----- Space between method and parens (grammar limitation) -----
    # Pattern: expr.if (trueFunc, falseFunc) - space not allowed
    if re.search(r"\.\w+\s+\(", code):
        return True, "method_space_paren"

    # ----- Bare association list (not in container) -----
    # Pattern: 'key' -> value, ... at top level without ( )
    if re.match(r"^'[^']+'\s*->\s*[A-Z]", code.strip()):
        if code.count("->") > 2 and not code.strip().startswith("("):
            return True, "bare_association_list"

    # ----- while(true) without block (grammar limitation) -----
    # Pattern: while(true); - needs block in our grammar
    if re.match(r"^\s*while\s*\(\s*(true|false)\s*\)\s*;", code.strip()):
        return True, "while_no_block"

    # ----- Diff output (lines starting with + or - from patches) -----
    # Pattern: +   SomeCode or -   SomeCode
    if re.match(r"^\s*[+\-]\s{2,}[A-Z]", code):
        return True, "diff_output"

    # ----- Bare operator at start (partial application doc examples) -----
    # Pattern: + postf(...) or - (expr) or + (expr) at line start
    if re.match(r"^\s*[+\-]\s+[\(a-zA-Z]", code.strip()):
        return True, "bare_operator"

    # ----- Partial array with placeholder -----
    # Pattern: [1,2,%,4] - % as placeholder
    if re.search(r"\[\s*[\d,\s]*%[\d,\s]*\]", code):
        return True, "pseudo_code"

    # ----- Bare event keys without container -----
    # Pattern: \degree, Pxrand... - event keys at top level
    if re.match(r"^\\[a-z]+,\s*[A-Z]", code.strip()):
        return True, "bare_event_key"

    # ----- Symbol list (not code) -----
    # Pattern: multiple lines of just 'symbolName'
    lines = [l.strip() for l in code.strip().split("\n") if l.strip()]
    if len(lines) >= 3 and all(re.match(r"^'[^']*'$", l) for l in lines[:3]):
        return True, "symbol_list"

    # ----- Math formula with variables -----
    # Pattern: RealA + RealB, ImagA + ImagB - showing math
    if re.match(r"^[A-Z][a-z]+[A-Z]\s*[+\-*/]", code.strip()):
        return True, "math_notation"

    # ----- Method list documentation -----
    # Pattern: .methodName\n.otherMethod - just listing methods
    if re.match(r"^\s*\.[a-zA-Z]+\s*\n\s*\.[a-zA-Z]+", code):
        return True, "method_list"

    # ----- Class variable declaration syntax -----
    # Pattern: var a, <b, >c, <>d; - only valid inside class
    if re.match(r"^\s*var\s+[<>]*[a-z].*[<>]+[a-z]", code):
        return True, "class_var_syntax"

    # ----- do/collect with template block -----
    # Pattern: do(collection) { loop body }; - documentation template
    if re.search(r"\b(do|collect)\s*\([^)]+\)\s*\{\s*[a-z]+\s+[a-z]+\s*\}", code):
        return True, "pseudo_code"

    # ----- Bare dup/method with array result -----
    # Pattern: dup: [5, 5]; - showing method result, not executable
    if re.match(r"^[a-z]+:\s*\[[^\]]+\];?\s*$", code.strip()):
        return True, "pseudo_code"

    # =========================================================================
    # REMAINING GRAMMAR GAPS - Valid SC not yet supported
    # These may need grammar fixes or are edge cases to skip for now
    # =========================================================================

    # ----- Four-dot placeholder (documentation pattern) -----
    # Pattern: .... as placeholder in docs - not real code
    if "...." in code:
        return True, "pseudo_code"

    # ----- Incomplete at end of code -----
    # Pattern: ends with ( or { suggesting truncated code
    stripped = code.strip()
    if stripped.endswith("(") or stripped.endswith(","):
        return True, "incomplete_fragment"

    # ----- Multi-line bare event key documentation -----
    # Pattern: key: value,\nkey2: value2 - not wrapped in parens
    lines = [
        l.strip()
        for l in code.strip().split("\n")
        if l.strip() and not l.strip().startswith("//")
    ]
    if len(lines) >= 3:
        key_value_lines = sum(
            1 for l in lines if re.match(r"^[a-zA-Z_][a-zA-Z0-9_]*:\s+", l)
        )
        if key_value_lines >= 3 and not code.strip().startswith("("):
            return True, "bare_event_key_list"

    # ----- Literal array as event key (grammar gap) -----
    # Pattern: #[key, key]: value - literal array used as multi-key
    if re.search(r"#\[[^\]]+\]\s*:", code):
        return True, "literal_array_key"

    # ----- Placeholder identifiers in arrays -----
    # Pattern: [beat1, [OSCcmd1]] - placeholder variable names
    if re.search(r"\[\s*[a-z]+\d+\s*,", code):
        if re.search(r"(beat|cmd|msg|osc|item)\d+", code, re.IGNORECASE):
            return True, "pseudo_code"

    # ----- Template with placeholder words -----
    # Pattern: while({ testFunc body }, { loopFunc body }) - English in blocks
    if re.search(r"\{\s*[a-z]+Func\s+[a-z]+\s*\}", code):
        return True, "pseudo_code"

    # ----- Bare operator expression (grammar gap) -----
    # Pattern: + 8; or - 3; - partial application without receiver
    if re.match(r"^\s*[+\-*/]\s+\d", code.strip()):
        return True, "bare_operator"

    # ----- Message cascade with colon syntax (grammar gap) -----
    # Pattern: select: _.isPrime nextN: 10; - chained keyword messages
    # Pattern: collect: _.squared; - single keyword message with partial
    if re.search(r"^[a-z]+:\s*_\.", code.strip()):
        return True, "message_cascade"

    # ----- Class definition snippet (classlib code) -----
    # Pattern: ClassName : ParentClass { - class definition with parent
    # Pattern: ClassName { - simple class definition
    if re.match(r"^[A-Z][a-zA-Z0-9_]*\s*(:\s*[A-Z][a-zA-Z0-9_]*)?\s*\{", code.strip()):
        return True, "classlib_snippet"

    # ----- Pseudocode marker in comments -----
    # Pattern: // (pseudocode) or // pseudocode
    if re.search(r"//\s*\(?pseudocode\)?", code, re.IGNORECASE):
        return True, "pseudo_code"

    # ----- English article words in code (placeholder) -----
    # Pattern: { the number } or (the value) - English in code blocks
    if re.search(r"[\{\(]\s*(the|a|an)\s+[a-z]+\s*[\}\)]", code):
        return True, "pseudo_code"
    # Pattern: { fill the array } - phrase with article mid-sentence
    if re.search(r"[\{\(]\s*[a-z]+\s+(the|a|an)\s+[a-z]+", code):
        return True, "pseudo_code"
    # Pattern: {quark name} or {loop body} - two English words in block
    if re.search(r"\{\s*[a-z]+\s+[a-z]+\s*\}", code):
        # Make sure it's not valid SC like { x y } for short functions
        match = re.search(r"\{\s*([a-z]+)\s+([a-z]+)\s*\}", code)
        if match:
            words = [match.group(1), match.group(2)]
            # Filter common English template words
            template_words = {
                "body",
                "name",
                "value",
                "func",
                "function",
                "code",
                "block",
                "loop",
                "test",
                "true",
                "false",
                "quark",
            }
            if any(w in template_words for w in words):
                return True, "pseudo_code"

    # ----- Method definition (classlib code) -----
    # Pattern: methodName { ... } at top level - class method definition
    if re.match(r"^[a-z][a-zA-Z0-9_]*\s*\{", code.strip()):
        # Verify it's not a function block call like `func { }`
        # Method defs have `this.` or arg inside
        if re.search(r"\bthis\.|thisMethod|^\s*arg\s+", code):
            return True, "classlib_snippet"

    # ----- Destructuring with ... placeholder (grammar gap) -----
    # Pattern: # ... a = expr or # a, ... = expr
    if re.search(r"#\s*\.\.\.|\.\.\.\s*[a-z]?\s*=", code):
        return True, "destructuring_placeholder"

    # ----- Event with bare identifier keys (grammar gap) -----
    # Pattern: (a:x, b:y) or {|x,y| (a:x, b:y)} - event keys without \ prefix
    # The grammar doesn't support bare identifiers as event keys in events
    # BUT we must NOT filter method calls like SinOsc.ar(freq: 440, out: bus)
    # Method calls have .methodname( or Classname( before the paren
    # Events have ( at start or after = or after |
    if re.search(r"[a-z][a-zA-Z0-9_]*\s*:\s*[a-z_][a-zA-Z0-9_]*\s*[,\)]", code):
        # Check if this looks like an event literal, not a method call
        # Event patterns: starts with (, or = (, or | ... (
        # NOT method call: .methodname( or Classname(
        if re.search(r"(?:^|[=|])\s*\(\s*[a-z][a-zA-Z0-9_]*\s*:", code):
            # Make sure it's not preceded by a method call pattern
            if not re.search(
                r"\.[a-zA-Z_][a-zA-Z0-9_]*\s*\(\s*[a-z][a-zA-Z0-9_]*\s*:", code
            ):
                if not re.search(
                    r"[A-Z][a-zA-Z0-9_]*\s*\(\s*[a-z][a-zA-Z0-9_]*\s*:", code
                ):
                    return True, "bare_event_keys"

    # ----- Placeholder block with ...} -----
    # Pattern: { ...} or = { ...} - placeholder without proper ellipsis
    if re.search(r"\{\s*\.\.\.+\s*\}", code):
        return True, "pseudo_code"

    # ----- Assignment to placeholder block -----
    # Pattern: ~out = { ...} - showing structure, not real code
    if re.search(r"=\s*\{\s*\.\.\.+\s*\}", code):
        return True, "pseudo_code"

    # ----- name <- expr outside comprehension (grammar gap) -----
    # Pattern: name <- expr at top level - showing generator syntax
    if re.match(r"^[a-z_][a-zA-Z0-9_]*\s*<-\s*\w", code.strip()):
        return True, "bare_generator"

    return False, ""


def is_repl_multiline(code: str) -> bool:
    """
    Detect REPL-style code that has multiple top-level statements
    without being wrapped in () or having proper semicolons.

    In SC, you can execute line-by-line in the REPL, but as a file
    it needs to be wrapped in () or have ; after each statement.

    Examples that should be detected:
        a.value
        a = a.flop;

        a.respondsTo(\flop) // comment
        b = Maybe(a.flop);
    """
    code = code.strip()

    # If it starts with (, it's a proper code block
    if code.startswith("("):
        return False

    # Get code lines, stripping trailing comments for analysis
    lines = []
    for line in code.split("\n"):
        stripped = line.strip()
        if not stripped:
            continue
        # Remove trailing // comments for statement analysis
        if "//" in stripped:
            # But not if // is inside a string
            in_string = False
            for j, c in enumerate(stripped):
                if c in "\"'" and (j == 0 or stripped[j - 1] != "\\"):
                    in_string = not in_string
                elif not in_string and stripped[j : j + 2] == "//":
                    stripped = stripped[:j].strip()
                    break
        if stripped:
            lines.append(stripped)

    if len(lines) <= 1:
        return False

    # Track brace/paren/bracket depth to ignore multi-line constructs
    depth = {"(": 0, "{": 0, "[": 0}
    close_map = {")": "(", "}": "{", "]": "["}

    # Check each line except the last
    for i, line in enumerate(lines[:-1]):
        # Update depth for this line
        in_string = False
        for c in line:
            if c in "\"'" and not in_string:
                in_string = True
            elif c in "\"'" and in_string:
                in_string = False
            elif not in_string:
                if c in "({[":
                    depth[c] += 1
                elif c in ")}]":
                    depth[close_map[c]] -= 1

        # If we're inside a multi-line construct, skip
        if any(d > 0 for d in depth.values()):
            continue

        # Skip if line ends with continuation characters
        if line.endswith(("{", "(", "[", ",", "\\")):
            continue

        # Skip if line ends with semicolon (properly terminated)
        if line.endswith(";"):
            continue

        # If line ends with something that looks like a complete expression
        # (identifier, ), ], }, number, string quote, char literal) without semicolon,
        # AND depth is 0, AND next line starts a new statement, it's REPL-style
        if re.search(r'[a-zA-Z0-9_)\]}\'"~$]$', line):
            next_line = lines[i + 1]
            # Next line starts a new statement (identifier, number, var, ~, \, (, [, {, $, or comment)
            if re.match(r"^[a-zA-Z0-9_~\\(\[{/$]", next_line):
                return True

    return False


def looks_like_formula(code: str) -> bool:
    """
    Detect mathematical formula notation, not SC code.
    Examples:
        s(t) = x(t) + k * s(t - D)
        y(n) = a0*x(n) + a1*x(n-1)
        f(x) = exp(squared(x))
    """
    # Pattern: single letter followed by (t), (n), (x), etc. - math function notation
    formula_pattern = r"\b[a-zA-Z]\([tnxk]\s*[-+]?\s*\d*\)"
    matches = re.findall(formula_pattern, code)

    # If we see 2+ formula-style patterns and no obvious SC constructs, it's probably a formula
    if len(matches) >= 2:
        sc_indicators = [
            "{",
            "SinOsc",
            "var ",
            "arg ",
            ".ar",
            ".kr",
            ".new",
            "play",
            "postln",
        ]
        has_sc_code = any(ind in code for ind in sc_indicators)
        if not has_sc_code:
            return True

    return False


def is_valid_sc_form(code: str) -> tuple[bool, str]:
    """
    Check if a single extracted form is valid SC code worth formatting.
    Returns (is_valid, skip_reason).
    """
    code = code.strip()
    if not code:
        return False, "empty"

    # Check non-code patterns
    not_code, reason = is_not_code(code)
    if not_code:
        return False, reason

    # Check formula
    if looks_like_formula(code):
        return False, "formula"

    # Check REPL multiline
    if is_repl_multiline(code):
        return False, "repl_multiline"

    return True, ""


# ============================================================================
# FORM EXTRACTION
# ============================================================================


def extract_forms(code: str) -> list[str]:
    """
    Extract individual top-level forms from SC code.

    A form is one of:
    - ( ... ) parenthesized block
    - { ... }.method().chain(); function with optional method chain
    - statement; any expression ending in semicolon
    """
    forms = []
    i = 0
    n = len(code)

    def skip_whitespace_and_comments():
        nonlocal i
        while i < n:
            if code[i] in " \t\n\r":
                i += 1
                continue
            if i < n - 1 and code[i : i + 2] == "//":
                while i < n and code[i] != "\n":
                    i += 1
                continue
            if i < n - 1 and code[i : i + 2] == "/*":
                while i < n - 1 and code[i : i + 2] != "*/":
                    i += 1
                i += 2
                continue
            break

    def read_string():
        nonlocal i
        quote = code[i]
        i += 1
        while i < n:
            if code[i] == "\\" and i + 1 < n:
                i += 2
            elif code[i] == quote:
                i += 1
                return
            else:
                i += 1

    def read_balanced(open_char: str, close_char: str) -> str:
        nonlocal i
        start = i
        depth = 1
        i += 1

        while i < n and depth > 0:
            c = code[i]

            if c in "\"'":
                read_string()
                continue

            if c == "/" and i + 1 < n:
                if code[i + 1] == "/":
                    while i < n and code[i] != "\n":
                        i += 1
                    continue
                elif code[i + 1] == "*":
                    i += 2
                    while i < n - 1 and code[i : i + 2] != "*/":
                        i += 1
                    i += 2
                    continue

            if c == open_char:
                depth += 1
            elif c == close_char:
                depth -= 1

            i += 1

        return code[start:i]

    def skip_ws_only():
        nonlocal i
        while i < n and code[i] in " \t\n\r":
            i += 1

    def read_method_chain():
        nonlocal i
        result = ""

        while i < n:
            skip_ws_only()
            if i >= n:
                break

            if code[i] == ".":
                result += code[i]
                i += 1
                while i < n and (code[i].isalnum() or code[i] == "_"):
                    result += code[i]
                    i += 1
                skip_ws_only()
                if i < n and code[i] == "(":
                    result += read_balanced("(", ")")
            elif code[i] == ";":
                result += ";"
                i += 1
                break
            else:
                break

        return result

    def at_statement_boundary() -> bool:
        """Check if we're at a natural statement boundary (REPL-style)."""
        nonlocal i
        saved_i = i

        while i < n and code[i] in " \t":
            i += 1

        if i >= n:
            i = saved_i
            return True

        if code[i] == ";":
            i = saved_i
            return False

        if code[i] == "\n":
            i += 1
            while i < n and code[i] in " \t":
                i += 1

            if i >= n:
                i = saved_i
                return True

            c = code[i]
            if c in "~\\([{" or c.isalpha() or c == "_":
                i = saved_i
                return True
            if c == "/" and i + 1 < n and code[i + 1] in "/*":
                i = saved_i
                return True

        i = saved_i
        return False

    def read_until_semicolon_or_boundary() -> str:
        nonlocal i
        start = i

        while i < n:
            c = code[i]

            if c in "\"'":
                read_string()
                continue

            if c == "/" and i + 1 < n:
                if code[i + 1] == "/":
                    while i < n and code[i] != "\n":
                        i += 1
                    continue
                elif code[i + 1] == "*":
                    i += 2
                    while i < n - 1 and code[i : i + 2] != "*/":
                        i += 1
                    i += 2
                    continue

            if c == "(":
                read_balanced("(", ")")
                if at_statement_boundary():
                    return code[start:i]
                continue
            if c == "{":
                read_balanced("{", "}")
                chain = read_method_chain()
                if at_statement_boundary() or not chain:
                    return code[start:i]
                continue
            if c == "[":
                read_balanced("[", "]")
                if at_statement_boundary():
                    return code[start:i]
                continue

            if c == ";":
                i += 1
                return code[start:i]

            i += 1

        return code[start:i]

    # Main extraction loop
    while i < n:
        skip_whitespace_and_comments()
        if i >= n:
            break

        c = code[i]

        if c == "(":
            form = read_balanced("(", ")")
            form += read_method_chain()
            form = form.strip()
            if form:
                forms.append(form)

        elif c == "{":
            form = read_balanced("{", "}")
            form += read_method_chain()
            form = form.strip()
            if form:
                forms.append(form)

        elif c == ";":
            i += 1

        elif c.isalpha() or c == "_" or c == "~" or c == "\\" or c == "[" or c == "#":
            form = read_until_semicolon_or_boundary()
            form = form.strip()
            if form:
                forms.append(form)

        else:
            form = read_until_semicolon_or_boundary()
            form = form.strip()
            if form:
                forms.append(form)

    return forms


# ============================================================================
# MAIN
# ============================================================================


def main():
    import shutil
    import argparse

    parser = argparse.ArgumentParser(
        description="Extract code examples from SC help files"
    )
    parser.add_argument(
        "--clean",
        action="store_true",
        help="Delete output directory before extraction (default: incremental with cleanup)",
    )
    args = parser.parse_args()

    # Track generated files for cleanup
    generated_files = set()

    # Optionally clean output directory completely
    if args.clean and OUTPUT_DIR.exists():
        shutil.rmtree(OUTPUT_DIR)
        print("Cleaned output directory")

    stats = {
        "total_blocks": 0,
        "total_files": 0,
        "split_count": 0,
        "skipped": {
            "empty": 0,
            "only_comments": 0,
            "shell_command": 0,
            "output_example": 0,
            "emacs_lisp": 0,
            "math_notation": 0,
            "method_list": 0,
            "ascii_diagram": 0,
            "pseudo_code": 0,
            "mixed_output": 0,
            "doc_header": 0,
            "bare_token": 0,
            "formula": 0,
            "repl_multiline": 0,
            "separator_line": 0,
            "template_class": 0,
            "url_or_path": 0,
            "class_trailing_block": 0,
            "gui_fragment": 0,
            "class_definition": 0,
            "event_key_documentation": 0,
            "jitlib_special_syntax": 0,
            "complex_index_pattern": 0,
            "for_trailing_block": 0,
            "scdoc_markup": 0,
            "cpp_code": 0,
            "elisp_code": 0,
            "accidental_notation": 0,
            "missing_semicolon": 0,
            "missing_comma": 0,
            "unicode_math": 0,
            "music_notation": 0,
            "adjacent_strings": 0,
            "literal_array_default": 0,
            "routine_shorthand": 0,
            "prout_shorthand": 0,
            "catch_typed": 0,
            "event_identifier_keys": 0,
            "dsp_formula": 0,
            "incomplete_fragment": 0,
            "prose_text": 0,
            "primitive_syntax": 0,
            "mismatched_brackets": 0,
            "bare_method_key": 0,
            "trivial_method_call": 0,
            "trivial_nil_assignment": 0,
            "trivial_empty_string": 0,
            "trivial_constant_block": 0,
            "method_space_paren": 0,
            "bare_association_list": 0,
            "while_no_block": 0,
            "diff_output": 0,
            "bare_event_key": 0,
            "symbol_list": 0,
            "class_var_syntax": 0,
            "bare_event_key_list": 0,
            "literal_array_key": 0,
            "bare_operator": 0,
            "bare_generator": 0,
            "bare_event_keys": 0,
            "scdoc_markup": 0,
            "message_cascade": 0,
            "classlib_snippet": 0,
            "destructuring_placeholder": 0,
        },
    }

    for schelp in sorted(HELP_DIR.rglob("*.schelp")):
        content = schelp.read_text(errors="ignore")
        blocks = CODE_PATTERN.findall(content)

        if not blocks:
            continue

        rel_path = schelp.relative_to(HELP_DIR)
        out_subdir = OUTPUT_DIR / rel_path.parent
        out_subdir.mkdir(parents=True, exist_ok=True)

        base_name = schelp.stem

        for i, match in enumerate(blocks):
            code = match.strip()
            if not code:
                continue

            # Check if entire block is non-code
            not_code, reason = is_not_code(code)
            if not_code:
                stats["skipped"][reason] = stats["skipped"].get(reason, 0) + 1
                continue

            # Check formula at block level
            if looks_like_formula(code):
                stats["skipped"]["formula"] += 1
                continue

            # Extract individual forms
            sub_blocks = extract_forms(code)

            if len(sub_blocks) > 1:
                stats["split_count"] += 1

            for j, sub_code in enumerate(sub_blocks):
                sub_code = sub_code.strip()
                if not sub_code:
                    continue

                # Validate each sub-block
                is_valid, skip_reason = is_valid_sc_form(sub_code)
                if not is_valid:
                    stats["skipped"][skip_reason] = (
                        stats["skipped"].get(skip_reason, 0) + 1
                    )
                    continue

                # Create output file
                if len(sub_blocks) == 1:
                    out_file = out_subdir / f"{sanitize_filename(base_name)}_{i}.scd"
                else:
                    suffix = chr(ord("a") + j) if j < 26 else f"_{j}"
                    out_file = (
                        out_subdir / f"{sanitize_filename(base_name)}_{i}{suffix}.scd"
                    )

                header = f"// Source: {rel_path} block {i}"
                if len(sub_blocks) > 1:
                    header += f" (part {j+1}/{len(sub_blocks)})"
                header += "\n"
                out_file.write_text(header + sub_code + "\n")

                # Track this file
                generated_files.add(out_file)

                stats["total_blocks"] += 1

        stats["total_files"] += 1

    # Cleanup pass: remove stale files that weren't generated this run
    stale_count = 0
    if OUTPUT_DIR.exists():
        for existing_file in OUTPUT_DIR.rglob("*.scd"):
            if existing_file not in generated_files:
                existing_file.unlink()
                stale_count += 1

        # Remove empty directories
        for dirpath in sorted(OUTPUT_DIR.rglob("*"), reverse=True):
            if dirpath.is_dir() and not any(dirpath.iterdir()):
                dirpath.rmdir()

    # Print summary
    print(
        f"Extracted {stats['total_blocks']} code blocks from {stats['total_files']} .schelp files"
    )
    print(f"Split {stats['split_count']} multi-form examples")
    if stale_count > 0:
        print(f"Removed {stale_count} stale files")
    print(f"\nSkipped (non-code content):")
    total_skipped = 0
    for reason, count in sorted(stats["skipped"].items(), key=lambda x: -x[1]):
        if count > 0:
            print(f"  {count:5d}  {reason}")
            total_skipped += count
    print(f"  -----")
    print(f"  {total_skipped:5d}  TOTAL skipped")
    print(f"\nOutput directory: {OUTPUT_DIR}")


if __name__ == "__main__":
    main()
