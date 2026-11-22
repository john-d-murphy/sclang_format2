// Source: Classes/Tdef.schelp block 5 (part 3/6)
(
Pset(\instrument, \pdef_grainlet,
	Ppar([
		Pbind(
			\dur, Tdef(\z),
			\note, Pseq([1, 3, 2, 1, 0], inf),
			\x, Pfunc { TempoClock.default.elapsedBeats.postln } // posts the onset times
		),
		Pbind(
			\dur, 4, // reference beat
			\sustain, 0.1,
			\note, 8
		)
	])
).play(quant: 1);
)
