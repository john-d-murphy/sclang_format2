// Source: Classes/Dpoll.schelp block 0 (part 5/8)
(
	{
	var x = Duty.kr(0.5, 0,
		Dpoll([Dseries(0, 1, inf), Dgeom(1, 1.1, inf)], ["first", "second"])
	);
	LFPulse.ar(100 + (x * 100)) * 0.1
	}.play
)
