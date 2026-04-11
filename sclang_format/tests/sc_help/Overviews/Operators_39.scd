// Source: Overviews/Operators.schelp block 39
(
{
	var a, b;
	a = FSinOsc.ar(800);
	b = FSinOsc.ar(XLine.kr(200,500,5));
	((a * a * b) - (a * b * b)) * 0.125
}.play)
