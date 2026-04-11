// Source: Tutorials/Mark_Polishook_tutorial/Japanese_version/15.schelp block 12 (part 2/3)
(
r = Routine({

	12.do({
		Synth("fm2", [\freq, 400.0.rrand(1200), \carPartial, 0.5.rrand(2), \ts, 0.1.rrand(4)]);
		2.wait;
	})
});
)
