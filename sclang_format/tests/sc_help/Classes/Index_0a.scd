// Source: Classes/Index.schelp block 0 (part 1/6)
(
{
	SinOsc.ar(
		Index.kr(
			LocalBuf.newFrom([ 200, 300, 400, 500, 600, 800 ]),
			LFSaw.kr(2.0).range(0, 7)
		),
		0,
		0.5
	)
}.play;
)
