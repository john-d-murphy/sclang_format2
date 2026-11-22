// Source: Classes/Splay.schelp block 0 (part 1/10)
(
x = { |spread = 1, level = 0.2, center = 0.0|
	var numchans = 10;
	Splay.ar(
		SinOsc.ar({ |i| LFNoise2.kr(1).exprange(200, 4000) } ! numchans),
		spread,
		level,
		center
		// use levelComp default true
	);
}.play;
)
