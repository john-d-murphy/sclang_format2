// Source: Classes/UGen.schelp block 18
(
{
	var a = Line.ar(0, 1, 0.008);
	var b = a |==| 0.5;
	var c = a.round(0.01) |==| 0.5;
	[a, Trig1.ar(b, 0.001), Trig1.ar(c, 0.001)]
}.plot
)
