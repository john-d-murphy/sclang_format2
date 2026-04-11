// Source: Tutorials/JITLib/jitlib_fading.schelp block 6 (part 5/6)
(
~out = { arg t_trig;
	FreeSelf.kr(t_trig);
	PinkNoise.ar([1,1]*0.3);
};
)
