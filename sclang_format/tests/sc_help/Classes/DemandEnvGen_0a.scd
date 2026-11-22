// Source: Classes/DemandEnvGen.schelp block 0 (part 1/18)
(
	{
		var freq;
		freq = DemandEnvGen.ar(
				Dseq([204, 400, 201, 502, 300, 200], inf),
				Drand([1.01, 0.2, 0.1, 2], inf) * MouseY.kr(0.01, 3, 1),
				7 // cubic interpolation
			);
		SinOsc.ar(freq * [1, 1.01]) * 0.1

	}.play;
)
