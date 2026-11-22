// Source: Classes/Klank.schelp block 4 (part 3/8)
(
SynthDef("help-KlankScaling", { |out = 0, freq = 0, rings = #[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0], pan = 0|
	var e = EnvGen.kr(Env(#[1, 1, 0], #[0.4, 0.01]), doneAction: Done.freeSelf);
	var i = Decay.ar(Impulse.ar(0), 0.03, ClipNoise.ar(0.01));
	var z = Klank.ar(
		`[(1..12), nil, rings], 				// specs (partials, amplitudes, ringtimes)
		i, 							// input
		freq, 							// scale to this frequency
		0, 							// frequency offset
		MouseX.kr(0.2, 3)				// scale decay times
	);
	Out.ar(out, Pan2.ar(z*e, pan));
}).add;

r = Routine{
	var sustain = 8, transition = 3;
	var mode = #[0, 2, 4, 5, 7, 9, 11, 12, 14, 16, 17, 19, 21, 23, 24];
	0.5.wait;			// wait for the synthdef to be sent to the server
	inf.do{ |i|
		Synth("help-KlankScaling", [
			\freq, (72 + (mode @@ i)).midicps,
			\rings, { 0.1.rrand(2) }.dup(12)
		]);
		0.2.wait;
	}
};
r.play;
)
