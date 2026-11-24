// Source: Classes/SynthDef.schelp block 8 (part 3/9)
(
~makeEffect.value(\reverb, { |in, env|
	// in and env come from the wrapper.
	var input;
	input = in;
	16.do({ input = AllpassC.ar(input, 0.04, Rand(0.001, 0.04), 3) });
	input
},
nil, // no lags
2	// numChannels
);
)
