// Source: Classes/Duty.schelp block 2
(
	{
		var a, n=5, m=64;
		a = {
			var x;
			x = { 0.2.rand2 } ! m;
			x = x ++ ({  Drand({ 0.2.rand2 } ! n) } ! m.rand);
			Dseq(x.scramble, inf)
		} ! n;
		Duty.ar(
				MouseX.kr(1, 125, 1) * SampleDur.ir * [1, 1.02],
				0,
				Dswitch1(a, MouseY.kr(0, n-1))
			)

	}.play;
)
