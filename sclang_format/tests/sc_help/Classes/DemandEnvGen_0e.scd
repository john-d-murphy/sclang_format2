// Source: Classes/DemandEnvGen.schelp block 0 (part 5/18)
(
	{
		var freq;
		freq = DemandEnvGen.kr(
				Dseq([Dseries(400, 200, 5), 500, 800, 530, 4000, 900], 2),
				Dseq([0.2, 0.1, 0.2, 0.3, 0.1], inf),
				Dseq([1, 0, 0, 6, 1, 1, 0, 2], inf), // shapes
				0,
				MouseX.kr > 0.5, // gate
				MouseButton.kr > 0.5, // reset
				doneAction: Done.none
			);
		SinOsc.ar(freq * [1, 1.001]) * 0.1

	}.play;
)
