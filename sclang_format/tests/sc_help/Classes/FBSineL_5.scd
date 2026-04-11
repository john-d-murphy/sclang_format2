// Source: Classes/FBSineL.schelp block 5
(
{ FBSineL.ar(
	LFNoise2.kr(1, 1e4, 1e4),
	LFNoise2.kr(1, 32, 33),
	LFNoise2.kr(1, 0.5),
	LFNoise2.kr(1, 0.05, 1.05),
	LFNoise2.kr(1, 0.3, 0.3)
) * 0.2 }.play(s);
)
