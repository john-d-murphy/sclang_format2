// Source: Classes/QuadC.schelp block 3
(
{ var r;
	r = MouseX.kr(3.5441, 4);	// stable range
	SinOsc.ar(QuadC.ar(40, r.neg, r, 0, 0.1, 800, 900)) * 0.4;
}.play(s);
)
