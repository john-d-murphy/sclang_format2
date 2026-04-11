// Source: Guides/Tour_of_UGens.schelp block 38
(
{
	var in;
	in = SinOsc.ar(300, 0, MouseX.kr(0.1,8pi,1));
	SinOsc.ar(0, in, 0.2); // 0 Hz sine oscillator
}.scope(1);
)
