// Source: Overviews/Operators.schelp block 19
(
{
	var mx = MouseX.kr(-20, 20);
	var my = MouseY.kr(-20, 20);
	SinOsc.ar(SinOsc.kr(0.3) * 20 lcm: [mx, my] * 30 + 500) * 0.1
}.play;
)
