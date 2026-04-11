// Source: Classes/LocalBuf.schelp block 2 (part 7/11)
(
{
	var buf;
	var list = Wavetable.sineFill(512, 1.0 / [1, 10, 3, 10, 5, 6, 10]);
	// list.plot;
	buf = LocalBuf.newFrom(list);
	Osc.ar(buf,
		XLine.kr(2000, 200 + {30.0.rand}.dup, 10) + SinOsc.ar(Line.kr(2, 300, 10),
		0, 100)
	) * 0.1;
}.play;
)
