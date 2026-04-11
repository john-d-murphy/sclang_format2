// Source: Classes/TBall.schelp block 0 (part 5/5)
(
	{
	var sc, g, d, z, lfo, rate;
	g = MouseX.kr(0.01, 100, 1);
	d = MouseY.kr(0.00001, 0.2);
	sc = #[451, 495.5, 595, 676, 734.5]; //azande harp tuning by B. Guinahui
	lfo = LFNoise1.kr(1, 0.005, 1);
	rate = 2.4;
	rate = rate * sc.size.reciprocal;
	z = sc.collect { |u,i|
		var f, in;
		in = Decay.ar(
				Mix(Impulse.ar(rate, [1.0, LFNoise0.kr(rate / 12)].rand, 0.1)), 					0.001
			);
		in = Ringz.ar(in,
					Array.fill(4, { |i| (i+1) + 0.1.rand2 }) / 2
					* Decay.ar(in,0.02,rand(0.5,1), lfo)						* u,
					Array.exprand(4, 0.2, 1).sort
					);
		in = Mix(in);
		f = TBall.ar(in * 10, g, d, 0.001);

		in + Mix(Ringz.ar(f, u * Array.fill(4, { |i| (i+1) + 0.3.rand2 }) * 2, 0.1))
	};
	Splay.ar(z) * 0.8
	}.play;
)
