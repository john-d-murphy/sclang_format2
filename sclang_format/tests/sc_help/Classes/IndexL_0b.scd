// Source: Classes/IndexL.schelp block 0 (part 2/6)
(
{
	SinOsc.ar(
		IndexL.kr(
			LocalBuf.newFrom([200, 300, 400, 500, 600, 800].scramble),
			MouseX.kr(0, 7)
		),
		0,
		0.5
	)
}.play;
)
