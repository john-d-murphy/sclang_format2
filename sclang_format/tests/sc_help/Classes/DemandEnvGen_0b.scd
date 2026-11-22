// Source: Classes/DemandEnvGen.schelp block 0 (part 2/18)
(
	{
		var freq, list;
		list = { exprand(200, 1000.0) } ! 32;
		freq = DemandEnvGen.ar(
				{ Dseq(list.scramble, inf) } ! 2,
				SampleDur.ir * MouseY.kr(1, 3000, 1),
				5, // curve interpoaltion
				MouseX.kr(-0.01, -4) // curve must be negative for fast interpol.
			);
		SinOsc.ar(freq) * 0.1

	}.play;
)
