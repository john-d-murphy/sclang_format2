// Source: Tutorials/JITLib/jitlib_basic_concepts_03.schelp block 2 (part 1/5)
~z[1..4] = { SinOsc.ar(exprand(300, 600), 0, LFTri.kr({exprand(1, 3)} ! 3).sum.max(0)) * 0.1 };
