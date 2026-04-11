// Source: Tutorials/JITLib/jitlib_basic_concepts_04.schelp block 0 (part 10/17)
~y = { Ringz.ar(Impulse.ar(1), 600, 0.05).dup };

// for simplicity, one can provide a clock and a quant for a whole proxy space:

p.clock = TempoClock.default;
