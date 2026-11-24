// Source: Classes/DemandEnvGen.schelp block 0 (part 8/18)
(
	{
		var freq;
		freq = DemandEnvGen.kr(
				Dseq([1300, 500, 800, 300, 400], 1),
				0.2,
				0,
				doneAction: Done.freeSelf
			);
		SinOsc.ar(freq * [1, 1.01]) * 0.1

	}.play;
)
