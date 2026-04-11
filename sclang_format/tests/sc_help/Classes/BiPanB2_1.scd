// Source: Classes/BiPanB2.schelp block 1
(
{
	var w, x, y, p, q, a, b, c, d;

	p = LFSaw.ar(200);
	q = LFSaw.ar(301);

	// B-format encode
	#w, x, y = BiPanB2.ar(p, q, MouseX.kr(-1,1), 0.1);

	// B-format decode to quad
	#a, b, c, d = DecodeB2.ar(4, w, x, y);

	[a, b, d, c] // reorder to my speaker arrangement: Lf Rf Lr Rr
}.play;
)
