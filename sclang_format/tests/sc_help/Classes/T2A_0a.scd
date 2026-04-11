// Source: Classes/T2A.schelp block 0 (part 1/3)
(
{
	var trig = Impulse.kr(MouseX.kr(1, 100, 1));
	Ringz.ar(T2A.ar(trig), 800, 0.01) * 0.4
}.play;
)
