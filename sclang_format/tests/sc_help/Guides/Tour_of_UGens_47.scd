// Source: Guides/Tour_of_UGens.schelp block 47
(
{
	var w, x, y, p, lf, rf, rr, lr;

	p = BrownNoise.ar; // source

	// B-format encode
	#w, x, y = PanB2.ar(p, MouseX.kr(-1,1), 0.3);

	// B-format decode to quad. outputs in clockwise order
	#lf, rf, rr, lr = DecodeB2.ar(4, w, x, y);

	[lf, rf, lr, rr] // reorder to my speaker arrangement: Lf Rf Lr Rr
}.scope(4);
)
