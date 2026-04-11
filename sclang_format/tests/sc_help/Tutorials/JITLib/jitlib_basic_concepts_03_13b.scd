// Source: Tutorials/JITLib/jitlib_basic_concepts_03.schelp block 13 (part 2/2)
~y = { arg freq=500; Formant.ar(50, freq * [1, 1.1], 70) * 0.1 };
