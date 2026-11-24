// Source: Tutorials/JITLib/jitlib_basic_concepts_03.schelp block 1 (part 1/8)
~z = (~y * pi).sin * 0.1 * { LFSaw.kr(LFNoise1.kr(0.1 ! 3).sum * -18).max(0.2) };
