// Source: Guides/Tour_of_UGens.schelp block 59 (part 3/3)
( // using user supplied window
{
	var trigrate, winsize, trig;
	trigrate = MouseX.kr(2, 120);
	winsize = trigrate.reciprocal;
	trig = Impulse.ar(trigrate);
	GrainSin.ar(2, trig, winsize, TRand.ar(440.0, 880.0, trig), LFNoise1.kr(0.2),
		b, 512, 0.2)
}.scope(2, zoom: 4);
)
