// Source: Guides/Order-of-execution.schelp block 10 (part 5/9)
~xfer = { Out.ar(0, 0.25 * In.ar(b, 2)) }.play(s, addAction: \addToTail);
