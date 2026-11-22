// Source: Classes/InRect.schelp block 0 (part 1/7)
(
{
	InRect.ar(
		SinOsc.ar(1), SinOsc.ar(1.3), Rect(0, 0.5, 0.5, 0.5)
	) * LFSaw.ar(44, 0, 0.1)
}.play
)
