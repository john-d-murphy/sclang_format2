// Source: Tutorials/JITLib/jitlib_basic_concepts_03.schelp block 15 (part 3/3)
~y = { arg freq=500; Formant.ar(4, freq * [1, 1.1], 70) * 0.1 };
