// Source: Classes/Klank.schelp block 4 (part 5/8)
(
SynthDef("help-KlankOverlapTexture2",
{ |out = 0, freqs = #[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0], rings = #[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0], atk = 5, sus = 8, rel = 5, pan = 0|
	var e = EnvGen.kr(Env.linen(atk, sus, rel, 1, 4), doneAction: Done.freeSelf);
	var i = BrownNoise.ar(0.0012);
	var z = Klank.ar(
		`[freqs, nil, rings], 	// specs
		i					// input
	);
	Out.ar(out, Pan2.ar(z*e, pan));
}).add;

r = Routine{
	var sustain = 6, transition = 4, overlap = 5;
	var period = transition*2+sustain/overlap;
	0.5.wait;			// wait for the synthdef to be sent to the server
	inf.do {
		Synth("help-KlankOverlapTexture2", [
			\atk, transition,
			\sus, sustain,
			\rel, transition,
			\pan, 1.0.rand2,
			\freqs, { 6000.0.linrand+80 }.dup(12),
			\rings, { 0.1.rrand(3) }.dup(12)
		]);
		period.wait;
	}
};
r.play;
)
