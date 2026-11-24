// Source: Classes/InRect.schelp block 0 (part 2/7)
(
{
	InRect.ar(
		LFNoise0.ar([140, 141]), LFNoise0.ar(143), Rect(0, 0, 0.5, 1)
	).lag(0.1) * LFSaw.ar(SinOsc.ar(10, 0, 5, 400), 0, 0.1)
}.play
)
