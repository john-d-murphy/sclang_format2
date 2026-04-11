// Source: Classes/HenonN.schelp block 1 (part 3/4)
(
{ HenonN.ar(
	SampleRate.ir/8,
	LFNoise2.kr(1, 0.2, 1.2),
	LFNoise2.kr(1, 0.15, 0.15)
) * 0.2 }.play(s);
)
