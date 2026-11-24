// Source: Classes/Gendy2.schelp block 1 (part 15/18)
(
{
	Mix.fill(10, {
		var freq = rrand(130, 160.3);
		
		Pan2.ar(
			SinOsc.ar(
				Gendy2.ar(
					6.rand, 6.rand, SinOsc.kr(0.1, 0, 0.49, 0.51), SinOsc.kr(0.13, 0, 0.49, 0.51),
					freq, freq, SinOsc.kr(0.17, 0, 0.49, 0.51), SinOsc.kr(0.19, 0, 0.49, 0.51),
					12, 12, 0.4.rand, 0.4.rand, 200, 400
				), 0, 0.1
			), 1.0.rand2
		)
	});
}.play
)
