// Source: Tutorials/JITLib/jitlib_basic_concepts_03.schelp block 10 (part 3/3)
~z = { SinOsc.ar({ExpRand(300, 660)} ! 2) * 0.1 };	// you can add a new function,
							// which is paused.

~z.resume;
