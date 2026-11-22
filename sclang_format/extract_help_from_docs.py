#!/usr/bin/env python3
"""
Cut the SuperCollider help's code into the formatter's test corpus, with
sclang, SuperCollider's own compiler, as the judge of what is SuperCollider.

    python3 extract_help_from_docs.py                     write tests/sc_help/
    python3 extract_help_from_docs.py --candidates DIR    write every form to DIR

Each code:: block of each .schelp file under HELP_DIR is cut into the forms a
person would evaluate one at a time (extract_forms). sclang compiles every form
with tests/judge.scd, which never runs one. The corpus is every form sclang
accepts, as it stands or with the names it reports undeclared declared in
front, as the form's context would have declared them; less the forms holding
bytes outside ASCII anywhere but in a string, a quoted symbol or a comment,
since sclang's lexer skips such bytes and so accepts prose in Japanese. A
corpus file is named after its help file and block, with a letter for its
place among the block's forms, and starts with a `// Source:` line.
tests/sc_help/VERSION says which SuperCollider's help it was cut from.

With --candidates, every form is written, named and headed the same way, and
nothing is judged: tests/sclang_judge.rs's corpus_design judges them itself to
check the corpus. Neither mode needs a server or makes a sound.
"""

import os
import re
import shutil
import subprocess
import sys
import tempfile
from pathlib import Path

HELP_DIR = Path("/usr/share/SuperCollider/HelpSource/")
OUTPUT_DIR = Path("tests/sc_help/")
JUDGE = Path("tests/judge.scd")
CODE_PATTERN = re.compile(r"code::\s*\n(.*?)\n::", re.DOTALL)


def sanitize_filename(name: str) -> str:
    """Remove/replace characters that are problematic in filenames."""
    return name.replace("/", "_").replace("\\", "_").replace(" ", "_")


def extract_forms(code: str) -> list[str]:
    """
    Cut SC code into the forms a person would evaluate one at a time.

    A form ends at a semicolon outside brackets, strings and comments, or at
    the end of a line that completes an expression when the next line of code
    starts a new statement. Whatever follows a closing bracket (`} ! 4`,
    `) * 2`, `}.play`, `.do { }`, a `.play` on the next line) belongs to the
    same form.
    """
    forms = []
    i = 0
    n = len(code)

    def skip_comment() -> bool:
        """Skip a comment at i, if there is one."""
        nonlocal i
        if code.startswith("//", i):
            while i < n and code[i] != "\n":
                i += 1
            return True
        if code.startswith("/*", i):
            end = code.find("*/", i + 2)
            i = n if end < 0 else end + 2
            return True
        return False

    def skip_literal() -> bool:
        """Skip a string, quoted symbol or character literal at i, if there is one."""
        nonlocal i
        c = code[i]
        if c == "$":
            i += 3 if code.startswith("$\\", i) else 2
            return True
        if c in "\"'":
            i += 1
            while i < n and code[i] != c:
                i += 2 if code[i] == "\\" else 1
            i += 1
            return True
        return False

    def read_balanced():
        nonlocal i
        depth = 0
        while i < n:
            if skip_comment() or skip_literal():
                continue
            if code[i] in "([{":
                depth += 1
            elif code[i] in ")]}":
                depth -= 1
            i += 1
            if depth == 0:
                return

    def at_statement_boundary() -> bool:
        """At the end of a line: does the next line of code start a new statement?"""
        nonlocal i
        saved_i = i
        while i < n:
            if code[i] in " \t\r\n":
                i += 1
            elif not skip_comment():
                break
        boundary = i >= n or code[i].isalnum() or code[i] in "_~\\([{\"'$#"
        i = saved_i
        return boundary

    while i < n:
        if code[i] in " \t\r\n;":
            i += 1
            continue
        if skip_comment():
            continue
        start = i
        # Whether the code so far could end here: a line ending in an operator
        # or a comma goes on to the next, whatever that starts with.
        complete = False
        while i < n:
            if skip_comment():
                continue
            c = code[i]
            if c == ";":
                i += 1
                break
            if c == "\n" and complete and at_statement_boundary():
                break
            if skip_literal():
                complete = True
            elif c in "([{":
                read_balanced()
                complete = True
            else:
                if not c.isspace():
                    complete = c.isalnum() or c == "_"
                i += 1
        forms.append(code[start:i].strip())

    return forms


def cut(out_dir: Path) -> list[Path]:
    """Write every form of the help under out_dir; return their paths, relative to it."""
    paths = []
    for schelp in sorted(HELP_DIR.rglob("*.schelp")):
        rel_path = schelp.relative_to(HELP_DIR)
        base_name = sanitize_filename(schelp.stem)
        blocks = CODE_PATTERN.findall(schelp.read_text(errors="ignore"))
        for i, block in enumerate(blocks):
            forms = extract_forms(block.strip())
            for j, form in enumerate(forms):
                header = f"// Source: {rel_path} block {i}"
                if len(forms) == 1:
                    name = f"{base_name}_{i}.scd"
                else:
                    suffix = chr(ord("a") + j) if j < 26 else f"_{j}"
                    name = f"{base_name}_{i}{suffix}.scd"
                    header += f" (part {j+1}/{len(forms)})"
                path = rel_path.parent / name
                (out_dir / path).parent.mkdir(parents=True, exist_ok=True)
                (out_dir / path).write_text(header + "\n" + form + "\n")
                paths.append(path)
    return paths


def compile_all(directory: Path, work: Path) -> dict[Path, tuple[bool, list[str]]]:
    """
    Compile every .scd file under directory in one headless sclang run: for
    each, by path relative to directory, whether sclang accepted it and the
    errors it posted. The same reading of tests/judge.scd as compile_all in
    tests/sclang_judge.rs.
    """
    env = dict(os.environ, XDG_DATA_HOME=str(work / "xdg"), QT_QPA_PLATFORM="offscreen")
    out = subprocess.run(
        ["timeout", "300", "sclang", str(JUDGE.resolve()), str(directory)],
        env=env,
        cwd=work,
        stdin=subprocess.DEVNULL,
        capture_output=True,
        text=True,
        errors="replace",
    ).stdout
    files = {}
    path, errors = None, []
    for line in out.splitlines():
        if line.startswith("@@judge file "):
            path, errors = Path(line[len("@@judge file ") :]).relative_to(directory), []
        elif line.startswith("@@judge accepted ") or line == "@@judge refused":
            files[path] = (line != "@@judge refused", errors)
        elif line == "@@judge done":
            return files
        elif line.startswith("ERROR: ") and path is not None:
            errors.append(line[len("ERROR: ") :])
    sys.exit(f"sclang did not finish judging {directory}:\n" + "\n".join(out.splitlines()[-30:]))


def undeclared_names(errors: list[str]) -> list[str]:
    """
    The names sclang reported undeclared, when that is all it refused the file
    for: a syntax error stops it before it looks up names, and declaring names
    cannot help an unknown class.
    """
    if any("syntax error" in e or "Parse error" in e or "Class not defined" in e for e in errors):
        return []
    found = (re.fullmatch(r"Variable '(.*)' not defined\.", e) for e in errors)
    return sorted({m.group(1) for m in found if m})


def accepted(candidates: Path, work: Path) -> list[Path]:
    """The forms under candidates that sclang accepts, as they stand or with their undeclared names declared."""
    verdicts = compile_all(candidates, work)
    retry_dir = work / "declared"
    retried = []
    for path, (ok, errors) in verdicts.items():
        names = undeclared_names(errors)
        if not ok and names:
            (retry_dir / path).parent.mkdir(parents=True, exist_ok=True)
            text = (candidates / path).read_text()
            (retry_dir / path).write_text(f"var {', '.join(names)};\n{text}")
            retried.append(path)
    if retried:
        second = compile_all(retry_dir, work)
        for path in retried:
            verdicts[path] = second[path]
    return sorted(path for path, (ok, _) in verdicts.items() if ok)


def non_ascii_in_code(text: str) -> bool:
    """Whether text holds a byte outside ASCII anywhere but in a string, a quoted symbol or a comment."""
    i, n = 0, len(text)
    while i < n:
        if text.startswith("//", i):
            end = text.find("\n", i)
            i = n if end < 0 else end
        elif text.startswith("/*", i):
            # Block comments nest in SuperCollider.
            depth, i = 1, i + 2
            while i < n and depth:
                if text.startswith("/*", i):
                    depth, i = depth + 1, i + 2
                elif text.startswith("*/", i):
                    depth, i = depth - 1, i + 2
                else:
                    i += 1
        elif text[i] in "\"'":
            quote, i = text[i], i + 1
            while i < n and text[i] != quote:
                i += 2 if text[i] == "\\" else 1
            i += 1
        elif not text[i].isascii():
            return True
        elif text[i] == "$":
            # A character literal: `$"` opens no string, and `$é` is code.
            i += 2 if text.startswith("$\\", i) else 1
            if i < n and not text[i].isascii():
                return True
            i += 1
        else:
            i += 1
    return False


def main():
    if sys.argv[1:2] == ["--candidates"] and len(sys.argv) == 3:
        out_dir = Path(sys.argv[2])
        shutil.rmtree(out_dir, ignore_errors=True)
        print(f"{len(cut(out_dir))} candidates in {out_dir}")
        return
    if len(sys.argv) != 1:
        sys.exit(__doc__)

    version = subprocess.run(["sclang", "-v"], capture_output=True, text=True).stdout
    version = re.search(r"sclang (\S+)", version).group(1)
    with tempfile.TemporaryDirectory() as tmp:
        work = Path(tmp)
        candidates = work / "candidates"
        paths = cut(candidates)
        valid = accepted(candidates, work)
        corpus = [
            path
            for path in valid
            if not non_ascii_in_code((candidates / path).read_text().split("\n", 1)[1])
        ]
        shutil.rmtree(OUTPUT_DIR, ignore_errors=True)
        for path in corpus:
            (OUTPUT_DIR / path).parent.mkdir(parents=True, exist_ok=True)
            shutil.copyfile(candidates / path, OUTPUT_DIR / path)
    (OUTPUT_DIR / "VERSION").write_text(
        f"Cut from the help of SuperCollider {version} ({HELP_DIR}) by extract_help_from_docs.py.\n"
    )
    print(
        f"{len(paths)} forms; sclang accepts {len(valid)}; "
        f"{len(valid) - len(corpus)} of those hold bytes outside ASCII in code; "
        f"{len(corpus)} written to {OUTPUT_DIR}"
    )


if __name__ == "__main__":
    main()
