// Source: Classes/GVerb.schelp block 0 (part 1/12)
(
SynthDef(\test, { |out, roomsize, revtime, damping, inputbw, spread = 15, drylevel, earlylevel,
	taillevel|

	var a = Resonz.ar(
		Array.fill(4, { Dust.ar(2) }),
		1760 * [1, 2, 4, 8],
		0.01
	).sum * 10;

	//	var a = SoundIn.ar(0);
	//	var a = PlayBuf.ar(1, 0);

	Out.ar(out,
		GVerb.ar(
			a,
			roomsize,
			revtime,
			damping,
			inputbw,
			spread,
			drylevel.dbamp,
			earlylevel.dbamp,
			taillevel.dbamp,
			roomsize, 0.3)
		+ a
	)
}).add
)
