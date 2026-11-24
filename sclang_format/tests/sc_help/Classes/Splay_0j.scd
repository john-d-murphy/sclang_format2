// Source: Classes/Splay.schelp block 0 (part 10/10)
(
x = { |spread = 1, level = 0.2, center = 0.0|
	var numchans = 10;
	Splay.arFill(numchans,
		{ |i| SinOsc.ar(LFNoise2.kr(rrand(10, 20), 200, i + 3 * 100))  },
		spread,
		level,
		center
	);
}.play;
)
