// Source: Classes/QuadL.schelp block 2
(
{ var r;
	r = MouseX.kr(3.5441, 4);	// stable range
	QuadL.ar(SampleRate.ir/4, r.neg, r, 0, 0.1) * 0.4;
}.play(s);
)
