// Source: Guides/Tour_of_UGens.schelp block 59 (part 1/3)
( // using default window
{
	var trigrate, winsize, trig;
	trigrate = MouseX.kr(2, 120);
	winsize = trigrate.reciprocal;
	trig = Impulse.ar(trigrate);
	GrainSin.ar(2, trig, winsize, TRand.ar(440.0, 880.0, trig), LFNoise1.kr(0.2),
		-1, 512, 0.2)
}.scope(2, zoom: 4);
)
