// Source: Tutorials/Mark_Polishook_tutorial/Japanese_version/15.schelp block 12 (part 1/3)
(
SynthDef("fm2", {
	arg bus = 0, freq = 440, carPartial = 1, modPartial = 1, index = 3, mul = 0.2, ts = 1;

	// インデックスの値は通常0から24まで
	// carPartial :: modPartial => car/mod ratio

	var mod;
	var car;

	mod = SinOsc.ar(
		freq * modPartial,
		0,
		freq * index * LFNoise1.kr(5.reciprocal).abs
	);

	car = SinOsc.ar(
		(freq * carPartial) + mod,
		0,
		mul
	);

	Out.ar(
		bus,
		car * EnvGen.kr(Env.sine(1), doneAction: Done.freeSelf, timeScale: ts)
	)
}).add;
)
