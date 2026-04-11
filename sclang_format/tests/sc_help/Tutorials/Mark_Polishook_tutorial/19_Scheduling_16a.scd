// Source: Tutorials/Mark_Polishook_tutorial/19_Scheduling.schelp block 16 (part 1/2)
(
// DEFINE A SYNTHDEF
SynthDef("echoplex", {
	ReplaceOut.ar(
		0,
		CombN.ar(
			In.ar(0, 1),
			0.35,
			[Rand(0.05, 0.3), Rand(0.05, 0.3)],
			// generate random values every time a synth is created
			7,
			0.5
		)
	)
}).add;

// DEFINE GROUPS TO CONTROL ORDER-OF-EXECUTION
// attach a ~source group to the head of the rootnode and
// an ~effects group to the tail of the rootenode
~source = Group.head(s);
~effect = Group.tail(s);

// DEFINE A ROUTINE
r = Routine({

	// loop is the same as inf.do, eg, create an infinite loop that runs forever
	loop({
		Synth.head(	// attach the synth to the head of the ~source group
			~source,
			"fm2",
			[
				\outbus, 0, \freq, 400.0.rrand(1200), \modPartial, 0.3.rrand(2.0),
				\carPartial, 0.5.rrand(11), \ts, 0.1.rrand(0.2)]
		);
		s.queryAllNodes;
		2.wait;
	})
});

// TURN ON EFFECTS
Synth.head(~effect, "echoplex");
Synth.tail(~effect, "echoplex");
)
