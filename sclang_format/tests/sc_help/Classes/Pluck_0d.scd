// Source: Classes/Pluck.schelp block 0 (part 4/4)
(
	{
		var freq, numparts;
		numparts = 50;
		freq = SinOsc.kr(Array.fill(numparts, {Rand(0.05, 0.2)}),
			Array.fill(numparts, {Rand(0, 1.0)})).range(1000, 3000);
		LeakDC.ar(
			Pan2.ar(
				Pluck.ar(
					WhiteNoise.ar(0.1).dup(numparts),
					Impulse.kr(Array.fill(numparts, {Rand(10, 12)})),
					100.reciprocal, freq.reciprocal, 2, Rand(0.01, 0.2), mul: 1),
				Array.fill(numparts, {Rand.new(-1.0, 1.0)}))
			.sum
			);
		}.play(s);
)
