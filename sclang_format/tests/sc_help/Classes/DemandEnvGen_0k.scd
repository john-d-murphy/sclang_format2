// Source: Classes/DemandEnvGen.schelp block 0 (part 11/18)
(
	{
		var freq;
		freq = DemandEnvGen.kr(
				Dseq([500, 800, 600], inf),
				0.03,
				1, 0, // linear
				ToggleFF.kr(Dust.kr(5)), // gate
				0 // reset

			);
		SinOsc.ar(freq * [1, 1.01]) * 0.1

	}.play;
)
