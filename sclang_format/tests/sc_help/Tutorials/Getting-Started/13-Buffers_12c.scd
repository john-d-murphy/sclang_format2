// Source: Tutorials/Getting-Started/13-Buffers.schelp block 12 (part 3/5)
(
x = play({
	Shaper.ar(
		b,
		SinOsc.ar(300, 0, Line.kr(0,1,6)),
		0.5
	)
});
)
