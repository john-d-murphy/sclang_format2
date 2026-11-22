// Source: Classes/Shaper.schelp block 1 (part 2/3)
(
{
	Shaper.ar(
		b,
		SinOsc.ar(440, 0.5pi, Line.kr(0, 1, 6)), // input cosine wave
		0.5 // scale output down because otherwise it goes between -1.05 and 0.5, distorting...
	)
}.scope;
)
