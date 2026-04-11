// Source: Classes/Rotate2.schelp block 2 (part 1/12)
(
{
	var w, x, y, p, q, a, b, c, d;

	p = WhiteNoise.ar(0.05); // source
	q = LFSaw.ar(200,0,0.03)+LFSaw.ar(200.37,0,0.03)+LFSaw.ar(201,0,0.03);

	// B-format encode 2 signals at opposite sides of the circle
	#w, x, y = PanB2.ar(p, -0.5) + PanB2.ar(q, 0.5);

	#x, y = Rotate2.ar(x, y, MouseX.kr(-1,1));

	// B-format decode to quad
	#a, b, c, d = DecodeB2.ar(4, w, x, y);

	[a, b, d, c] // reorder to my speaker arrangement: Lf Rf Lr Rr
}.play;
)
