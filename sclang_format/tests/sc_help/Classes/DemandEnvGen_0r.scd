// Source: Classes/DemandEnvGen.schelp block 0 (part 18/18)
(
	{
		var freq;
		freq = DemandEnvGen.kr(
				{ Dseq([300, 800, Drand([1000, 460, 300], 1), 400], inf) + 3.0.rand } ! 2,
				MouseY.kr(0.001, 2, 1),
				5, -4,
				MouseX.kr > 0.5
			);
		SinOsc.ar(freq) * 0.1

	}.play;
)
