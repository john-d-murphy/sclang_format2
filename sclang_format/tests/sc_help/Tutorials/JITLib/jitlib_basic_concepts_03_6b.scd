// Source: Tutorials/JITLib/jitlib_basic_concepts_03.schelp block 6 (part 2/7)
~z = { SinOsc.ar(ExpRand(20, 660) ! 2) * Saw.ar(ExpRand(200, 960) ! 2) * 0.1 };

~z.release;
