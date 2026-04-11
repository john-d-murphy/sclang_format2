// Source: Tutorials/JITLib/jitlib_basic_concepts_04.schelp block 0 (part 5/17)
~y = { Ringz.ar(Impulse.ar(1), 600, 0.05).dup };

// adding a common clock:
~x.clock = TempoClock.default;
