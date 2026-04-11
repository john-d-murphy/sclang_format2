// Source: Overviews/Operators.schelp block 21
(
{
	var mx = MouseX.kr(-200, 200);
	var my = MouseY.kr(-200, 200);
	SinOsc.ar(SinOsc.kr(0.3) * 20 gcd: [mx, my] * 30 + 500) * 0.1
}.play;
)
