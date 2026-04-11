// Source: Classes/Ndef.schelp block 18
(
Ndef(\x,
	\setsrc -> Pbind(\source,
		Pseq([
			{ LFTri.ar(280 * Line.kr(1.1, 0.4, rrand(2, 3)) + [0,1]) * 0.1 },
			{ Pulse.ar(40 + [0,1]) * 0.1 },
			{ LFTri.ar(LFTri.kr(1).round(1.0.rand) + 1 * 180 + [0,1], 0.04) * 0.3 },
		], inf),
		\dur, Prand([3, 2, 4], inf)
	)
).play;
)
