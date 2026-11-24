// Source: Tutorials/Streams-Patterns-Events3.schelp block 18 (part 1/2)
(
SynthDef( \help_SPE3_Mridangam, { |out, t_amp|
	var sound;

	sound = Resonz.ar(
		WhiteNoise.ar(70) * Decay2.kr( t_amp, 0.002, 0.1 ),
		60.midicps,
		0.02,
		4
	).distort * 0.4;

	Out.ar(out, sound);
	DetectSilence.ar(sound, doneAction: Done.freeSelf);
}).add;

SynthDef( \help_SPE3_Drone, { |out|
	var sound;
	sound = LPF.ar(
		Saw.ar([60, 60.04].midicps)
		+
		Saw.ar([67, 67.04].midicps),
		108.midicps,
		0.007
	);
	Out.ar(out, sound);
}).add;
)
