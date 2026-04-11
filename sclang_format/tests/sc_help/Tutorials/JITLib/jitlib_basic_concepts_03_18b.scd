// Source: Tutorials/JITLib/jitlib_basic_concepts_03.schelp block 18 (part 2/3)
~y = { arg freq=#[440, 550]; SinOsc.ar(freq) * SinOsc.ar(freq + 3) * 0.05 };
