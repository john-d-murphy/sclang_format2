// Source: Classes/SynthDef.schelp block 7 (part 6/6)
(
fork {
	z = Synth(\arrayarg);

	2.wait;
	10.do {
		z.setn(\freqs, { exprand(200, 800.0) } ! 4);
		(2 ** (0..3).choose * 0.2).wait;
	};

	z.set(\amp, -40.dbamp);

	10.do {
		z.setn(\freqs, { exprand(200, 800.0) } ! 4);
		(2 ** (0..3).choose * 0.2).wait;
	};
	2.wait;

	z.release;
};
)
