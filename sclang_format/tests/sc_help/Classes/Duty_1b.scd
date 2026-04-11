// Source: Classes/Duty.schelp block 1 (part 2/2)
(
	{
		var freq;
		freq = Duty.kr(
				Dseq([0.2, 0.3, 0.4, Dseq([1, 1, 1, 2, 1, 2], inf)]) / 2,
				Dseq([1, 2, 4, 5], inf), // demand rate reset
				Dseq([0, 1, 2, Dseq([1, 2, 3, 4, 5], inf)])
			) * 30 + 250;
		SinOsc.ar(freq * [1, 1.01]) * 0.1

	}.play;
)
