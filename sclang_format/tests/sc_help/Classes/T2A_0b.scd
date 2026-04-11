// Source: Classes/T2A.schelp block 0 (part 2/3)
(
{
	var trig = Impulse.kr(200);
	[T2A.ar(trig), K2A.ar(trig)].lag(0.001)
}.plot2(10/200);
)
