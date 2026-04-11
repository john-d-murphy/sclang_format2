// Source: Tutorials/Mark_Polishook_tutorial/18_Frequency_modulation.schelp block 0 (part 1/3)
(
SynthDef("fm1", { arg bus = 0, freq = 440, carPartial = 1, modPartial = 1, index = 3, mul = 0.05;

	// index values usually are between 0 and 24
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
