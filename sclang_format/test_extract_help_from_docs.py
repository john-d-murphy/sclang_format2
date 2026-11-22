"""
Tests of extract_help_from_docs.py's splitting. Run from sclang_format/:

    python3 -B -m unittest test_extract_help_from_docs
"""

import unittest

from extract_help_from_docs import extract_forms


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
            extract_forms("{ 1 }.play\n\n{ 2 }.play // two\nx = 5\ny = x +\n6\n-1"),
            ["{ 1 }.play", "{ 2 }.play // two", "x = 5", "y = x +\n6\n-1"],
        )

    def test_a_character_literal_is_not_a_bracket_or_a_quote(self):
        form = "s.sendMsg(\\s_new, \\a, $[, 0.95, $], \\freq, 220);"
        self.assertEqual(extract_forms(form + "\nx.free;"), [form, "x.free;"])
        self.assertEqual(extract_forms("[$', $\"];\n1;"), ["[$', $\"];", "1;"])


if __name__ == "__main__":
    unittest.main()
