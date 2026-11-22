// Source: Classes/LinCongL.schelp block 3
(
{
SinOsc.ar(
	LinCongL.ar(
		40,
		LFNoise2.kr(0.1, 0.1, 1),
		LFNoise2.kr(0.1, 0.1, 0.1),
		LFNoise2.kr(0.1),
		0, 500, 600
	)
) * 0.4 }.play(s);
)
