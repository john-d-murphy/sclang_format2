// Source: Tutorials/JITLib/jitlib_basic_concepts_03.schelp block 14 (part 3/4)
~y[2] = { arg freq=500; SinOsc.ar(freq * [1, 1.1]) * LFPulse.kr(Rand(1, 3)) * 0.1 };
