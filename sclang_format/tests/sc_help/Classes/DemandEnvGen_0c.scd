// Source: Classes/DemandEnvGen.schelp block 0 (part 3/18)
(
	{
		var freq;
		freq = DemandEnvGen.kr(
				Dwhite(300, 1000, inf).round(100),
				0.1,
				5, 0.3, // curve: 0.3
				MouseX.kr > 0.5,
				1
			);
		SinOsc.ar(freq * [1, 1.21]) * 0.1

	}.play;
)
