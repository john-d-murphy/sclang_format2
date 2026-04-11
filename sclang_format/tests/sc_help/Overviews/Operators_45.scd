// Source: Overviews/Operators.schelp block 45
(
{
	var a, b, c;
	a = FSinOsc.ar(800);
	b = FSinOsc.ar(XLine.kr(200,500,5));
	c = a + b;
	(c * c) * 0.125
}.play)
