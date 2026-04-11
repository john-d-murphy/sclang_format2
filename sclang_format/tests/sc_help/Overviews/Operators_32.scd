// Source: Overviews/Operators.schelp block 32
(
{
	var a, b;
	a = FSinOsc.ar(800);
	b = FSinOsc.ar(XLine.kr(200,500,5));
	((a * b) + a) * 0.125
}.play)
