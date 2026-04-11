// Source: Tutorials/Mark_Polishook_tutorial/19_Scheduling.schelp block 15 (part 2/3)
(
// DEFINE A ROUTINE
r = Routine({

	12.do({
		Synth(
			"fm2",
			[
				\bus, 2.rand, \freq, 400.0.rrand(1200),
				\carPartial, 0.5.rrand(2), \ts, 0.5.rrand(11)
			]
		);
		s.queryAllNodes;
		"".postln.postln.postln.postln.postln;
		2.wait;
	})
});
)
