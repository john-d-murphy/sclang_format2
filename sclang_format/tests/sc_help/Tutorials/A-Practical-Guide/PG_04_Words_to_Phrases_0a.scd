// Source: Tutorials/A-Practical-Guide/PG_04_Words_to_Phrases.schelp block 0 (part 1/2)
(
TempoClock.default.tempo = 1;
p = Pbind(
	\degree, Pseq([
		Pseries({ rrand(0, 7) }, 1, { rrand(4, 8) }),	// up (step = 1)
		Pseries({ rrand(0, 7) }, 1, { rrand(4, 8) }),	// up (step = 1)
		Pseries({ rrand(7, 14) }, -1, { rrand(4, 8) })	// down (step = -1)
	], inf),
	\dur, 0.125
).play;
)
