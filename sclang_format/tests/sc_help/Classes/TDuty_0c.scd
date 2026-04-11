// Source: Classes/TDuty.schelp block 0 (part 3/7)
(
	{
		var trig;
		trig = TDuty.ar(
				Dseq([0.1, 0.2, 0.4, 0.3], inf), // demand ugen as durations
				0,
				Dseq([0.1, 0.4, 0.01, 0.5, 1.0], inf) // demand ugen as amplitude
			);
		Ringz.ar(trig, 1000, 0.1)

	}.play;
)
