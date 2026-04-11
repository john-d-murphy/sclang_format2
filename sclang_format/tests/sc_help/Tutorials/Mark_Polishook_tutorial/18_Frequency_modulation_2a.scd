// Source: Tutorials/Mark_Polishook_tutorial/18_Frequency_modulation.schelp block 2 (part 1/3)
(
SynthDef("carrier", { arg inbus = 2, outbus = 0, freq = 440, carPartial = 1, index = 3, mul = 0.2;

	// index values usually are between 0 and 24
	// carPartial :: modPartial => car/mod ratio

	var mod;
	var car;

	mod = In.ar(inbus, 1);

	Out.ar(
		outbus,
		SinOsc.ar((freq * carPartial) + mod, 0, mul);
	)
}).add;

SynthDef("modulator", { arg outbus = 2, freq, modPartial = 1, index = 3;
	Out.ar(
		outbus,
		SinOsc.ar(freq * modPartial, 0, freq)
		*
		LFNoise1.kr(Rand(3, 6).reciprocal).abs
		*
		index
	)
}).add;
)
