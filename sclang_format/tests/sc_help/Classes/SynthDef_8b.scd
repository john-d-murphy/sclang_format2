// Source: Classes/SynthDef.schelp block 8 (part 2/9)
(
~makeEffect.value(\wah, { |in, env, rate = 0.7, ffreq = 1200, depth = 0.8, rq = 0.1|
	// in and env come from the wrapper. The rest are controls
 	var lfo;
	lfo = LFNoise1.kr(rate, depth * ffreq, ffreq);
	RLPF.ar(in, lfo, rq, 10).distort * 0.15;
},
[0.1, 0.1, 0.1, 0.1], // lags for rate ffreq, depth and rq
2	// numChannels
);
)
