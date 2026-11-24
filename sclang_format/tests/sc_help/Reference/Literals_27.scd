// Source: Reference/Literals.schelp block 27
(
// build a table of note names
var table = ();
value {
    var semitones = [0, 2, 4, 5, 7, 9, 11];
    var naturalNoteNames = ["c", "d", "e", "f", "g", "a", "b"];

    (0..9).do {|o|
        naturalNoteNames.do {|c, i|
            var n = (o + 1) * 12 + semitones[i];
            table[(c ++ o).asSymbol] = n;
            table[(c ++ "s"  ++ o).asSymbol] = n + 1;
            table[(c ++ "ss" ++ o).asSymbol] = n + 2;
            table[(c ++ "b"  ++ o).asSymbol] = n - 1;
            table[(c ++ "bb" ++ o).asSymbol] = n - 2;
        };
    };
};

// translate note names to midi keys
table.atAll(#[c4, e4, gs4, c5, e5, gs5, c6])
)
