// Source: Classes/Duty.schelp block 0 (part 2/2)
(
	{
		var freq;
		freq = Duty.kr(
				MouseX.kr(0.001, 2, 1), // control rate ugen as durations
				0,
				Dseq([204, 400, 201, 502, 300, 200], inf)
			);
		SinOsc.ar(freq * [1, 1.01]) * 0.1

	}.play;
)
