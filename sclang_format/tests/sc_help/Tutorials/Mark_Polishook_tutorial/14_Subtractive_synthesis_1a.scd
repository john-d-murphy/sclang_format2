// Source: Tutorials/Mark_Polishook_tutorial/14_Subtractive_synthesis.schelp block 1 (part 1/2)
(
SynthDef("subtractive", { arg out;
	Out.ar(
		out,
		LPF.ar(
			Pulse.ar(440, 0.5, 0.1),	// the source to be filtered
			Line.kr(8000, 660, 6)		// control the filter frequency with a line
		)
	)
}).add;
)
