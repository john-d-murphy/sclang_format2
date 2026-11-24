"""
Tests of extract_help_from_docs.py. Run from sclang_format/:

    python3 -B -m unittest test_extract_help_from_docs
"""

import unittest

from extract_help_from_docs import extract_forms, non_ascii_in_code, undeclared_names


class ExtractForms(unittest.TestCase):
    def test_a_closing_bracket_does_not_end_a_form_the_line_goes_on_with(self):
        for form in [
            "a.value = { 1.0.rand } ! 4;",
            "x = { |x| x + 1000 } + { |x| x * 100 };",
            "{ |x| x + 1000 } + { |x| x * 100 };",
            "(1..4) * 2;",
            "f = { |a| a } <> { |b| b };",
            "[1, 2] +.x [3, 4];",
            "f.(1)[0];",
            "{ 1 }.value(2) + 3;",
            "(1..10).do { |i| i.postln };",
            "Pbind(\\degree, 1)\n.play;",
            "{ 1 }\n// the sum\n+ { 2 };",
            "{ 1 }\n/* then */.play;",
        ]:
            with self.subTest(form=form):
                self.assertEqual(extract_forms(form), [form])

    def test_forms_end_at_a_semicolon_or_where_a_new_line_starts_a_new_one(self):
        self.assertEqual(
            extract_forms("(\n1 + 2\n) // three\n\n// four\n(\n2 + 2\n)\nx.free;"),
            ["(\n1 + 2\n) // three", "(\n2 + 2\n)", "x.free;"],
        )
        self.assertEqual(
            extract_forms('{ 1 }.value; "a".postln\nSynth(\\a)\n"b".postln'),
            ["{ 1 }.value;", '"a".postln', "Synth(\\a)", '"b".postln'],
        )
        self.assertEqual(
            extract_forms("{ 1 }.play\n\n{ 2 }.play // two\nx = 5\ny = x +\n6\n* 2"),
            ["{ 1 }.play", "{ 2 }.play // two", "x = 5", "y = x +\n6\n* 2"],
        )

    def test_a_negative_literal_starts_a_new_statement(self):
        self.assertEqual(extract_forms("0xa    // 10\n-0xd   // -13"), ["0xa    // 10", "-0xd   // -13"])
        self.assertEqual(extract_forms("inf\n-inf"), ["inf", "-inf"])
        self.assertEqual(extract_forms("x = 5 -\n-1"), ["x = 5 -\n-1"])
        self.assertEqual(extract_forms("y = x\n- 1"), ["y = x\n- 1"])

    def test_a_stray_closing_bracket_does_not_swallow_the_next_form(self):
        self.assertEqual(extract_forms("x = 1;\n)\n\n(\n2\n)"), ["x = 1;", ")", "(\n2\n)"])

    def test_a_character_literal_is_not_a_bracket_or_a_quote(self):
        form = "s.sendMsg(\\s_new, \\a, $[, 0.95, $], \\freq, 220);"
        self.assertEqual(extract_forms(form + "\nx.free;"), [form, "x.free;"])
        self.assertEqual(extract_forms("[$', $\"];\n1;"), ["[$', $\"];", "1;"])


class Judging(unittest.TestCase):
    def test_bytes_outside_ascii_count_only_in_code(self):
        for text in ['"π";', "'é';", "x; // ± 1", "/* /* 日本 */ é */ 1", '$"; "é"']:
            with self.subTest(text=text):
                self.assertFalse(non_ascii_in_code(text))
        for text in ["z = ±1", "これは", "x = 1\u00a0+ 2", "$é", "$\\é", '"a" ++ é']:
            with self.subTest(text=text):
                self.assertTrue(non_ascii_in_code(text))

    def test_names_are_declared_only_when_nothing_else_is_wrong(self):
        undeclared = ["Variable 'b' not defined.", "Variable 'a' not defined.", "Variable 'a' not defined."]
        self.assertEqual(undeclared_names(undeclared), ["a", "b"])
        self.assertEqual(undeclared_names(undeclared + ["Class not defined."]), [])
        self.assertEqual(undeclared_names(["syntax error, unexpected '!'"] + undeclared), [])


if __name__ == "__main__":
    unittest.main()
