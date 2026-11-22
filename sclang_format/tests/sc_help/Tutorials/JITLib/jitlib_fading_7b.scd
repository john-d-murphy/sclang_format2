// Source: Tutorials/JITLib/jitlib_fading.schelp block 7 (part 2/3)
(
~out = { arg out;
	OffsetOut.ar(out, Impulse.ar([10, 10],0,0.1))
}
)
