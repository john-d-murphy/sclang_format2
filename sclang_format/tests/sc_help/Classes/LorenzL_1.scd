// Source: Classes/LorenzL.schelp block 1
(
{ LorenzL.ar(
	SampleRate.ir,
	LFNoise0.kr(1, 2, 10),
	LFNoise0.kr(1, 20, 38),
	LFNoise0.kr(1, 1.5, 2)
) * 0.2 }.play(s);
)
