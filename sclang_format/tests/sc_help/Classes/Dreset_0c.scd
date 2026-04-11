// Source: Classes/Dreset.schelp block 0 (part 3/3)
(
{
	var a, nmax = 90;
	a = { Dreset(Dseries(0, 1, inf), Drand(0 ! nmax ++ 1, inf)) } ! 2;
	Duty.ar(SampleDur.ir, 0, a) * (0.1 / nmax)
}.play;
)
