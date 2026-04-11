// Source: Classes/LeastChange.schelp block 1 (part 1/4)
(
d = { arg freq=440;
	var internalFreq;
	internalFreq = LFNoise0.ar(0.3, 300, 800);
	SinOsc.ar(
		LeastChange.kr(freq, internalFreq) // two sources of change: one external, one internal
	) * 0.1
}.play
);
