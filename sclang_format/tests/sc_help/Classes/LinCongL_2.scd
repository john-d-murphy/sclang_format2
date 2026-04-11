// Source: Classes/LinCongL.schelp block 2
(
{ LinCongL.ar(
	LFNoise2.kr(1, 1e4, 1e4),
	LFNoise2.kr(0.1, 0.5, 1.4),
	LFNoise2.kr(0.1, 0.1, 0.1),
	LFNoise2.kr(0.1)
) * 0.2 }.play(s);
)
