// Source: Classes/DemandEnvGen.schelp block 0 (part 9/18)
(
	{
		var freq;
		freq = DemandEnvGen.kr(
				Dseq([300, 800], 1),
				1,
				1
			);
		SinOsc.ar(freq * [1, 1.01]) * 0.1

	}.play;
)
