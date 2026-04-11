// Source: Classes/RandSeed.schelp block 0 (part 6/11)
(
SynthDef("pseudorandom", { arg out, sustain=1, seed=1967, id=0;
	var noise, filterfreq;
	RandID.ir(id);
	RandSeed.ir(1, seed);


	noise = WhiteNoise.ar(0.05 ! 2) + Dust2.ar(70 ! 2);
	filterfreq = LFNoise1.kr(3, 5500, 6000);

	Out.ar(out,
		Resonz.ar(noise * 5, filterfreq, 0.5) + (noise * 0.5)
		*
		Line.kr(1, 0, sustain, doneAction: Done.freeSelf)
	)

}).add;
)
