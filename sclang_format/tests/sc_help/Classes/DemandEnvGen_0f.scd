// Source: Classes/DemandEnvGen.schelp block 0 (part 6/18)
(
	{
		var freq;
		freq = DemandEnvGen.kr(
				Dseq([Dseries(400, 200, 5), 500, 800, 530, 4000, 900], 2),
				0.1,
				3, 0,
				MouseX.kr > 0.5 - 0.1, // gate: sample and hold
				MouseButton.kr > 0.5 * 2, // hard reset
				doneAction: Done.none
			);
		SinOsc.ar(freq * [1, 1.001]) * 0.1

	}.play;
)
