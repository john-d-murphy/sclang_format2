// Source: Classes/Klank.schelp block 4 (part 7/8)
(
SynthDef("help-KlankOverlapTexture3",
{ |out = 0, freqs = #[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0], rings = #[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0], pan = 0|
	var e = EnvGen.kr(Env(#[1, 1, 0], #[18, 3]), doneAction: Done.freeSelf);
	var i = Decay.ar(Impulse.ar(Rand(0.2, 0.6)), 0.8, ClipNoise.ar(0.001));
	var z = Klank.ar(
		`[freqs, 2, rings], 	// specs
		i					// input
	);
	Out.ar(out, Pan2.ar(z*e, pan));
}).add;

r = Routine{
	0.5.wait;			// wait for the synthdef to be sent to the server
	inf.do {
		Synth("help-KlankOverlapTexture3", [
			\pan, 1.0.rand2,
			\freqs, { 12000.0.linrand+80 }.dup(12),
			\rings, { 3.rrand(10) }.dup(12)
		]);
		3.wait;
	}
};
r.play;
)
