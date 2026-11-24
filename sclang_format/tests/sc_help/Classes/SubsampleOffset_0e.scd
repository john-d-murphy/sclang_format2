// Source: Classes/SubsampleOffset.schelp block 0 (part 5/5)
(
	Routine {
		loop {
			s.sendBundle(0.2, [9, \Help_Subsample_Grain, -1, 1, 1, \freq, 1000]);
			rrand(0.001, 0.002).wait;
		}
	}.play;
)
