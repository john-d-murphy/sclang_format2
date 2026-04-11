// Source: Tutorials/Mark_Polishook_tutorial/Japanese_version/14.schelp block 0 (part 1/2)
(
SynthDef("fm1", { arg bus = 0, freq = 440, carPartial = 1, modPartial = 1, index = 3, mul = 0.05;

	// インデックスの値は通常は0から24まで
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
		car
	)
}).add;
)
