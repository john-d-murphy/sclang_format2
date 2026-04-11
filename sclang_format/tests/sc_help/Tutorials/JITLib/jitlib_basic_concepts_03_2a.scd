// Source: Tutorials/JITLib/jitlib_basic_concepts_03.schelp block 2 (part 1/3)
~z[1..4] = { SinOsc.ar(exprand(300, 600), 0, LFTri.kr({exprand(1, 3)} ! 3).sum.max(0)) * 0.1 };


// the function is assigned to the slots 1, 2 and 3 (subsequent)
~z[1..] = [ {SinOsc.ar(440) * 0.1 }, { SinOsc.ar(870) * 0.08 }, { SinOsc.ar(770) * 0.04 }];
