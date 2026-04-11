// Source: Classes/TDuty.schelp block 0 (part 4/7)
(
	{
		var trig;
		trig = TDuty.ar(
				MouseX.kr(0.001, 2, 1), // control rate ugen as durations
				0,
				Dseq([0.1, 0.4, 0.01, 0.5, 1.0], inf)
			);
		Ringz.ar(trig, 1000, 0.1)

	}.play;
)
