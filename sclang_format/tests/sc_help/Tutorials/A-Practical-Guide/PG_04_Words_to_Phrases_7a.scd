// Source: Tutorials/A-Practical-Guide/PG_04_Words_to_Phrases.schelp block 7 (part 1/2)
(
TempoClock.default.tempo = 1;
p = Pbind(
		// translation: if(0.7.coin) { rrand(-7, 0) } { rrand(7, 14 }
	\degree, Pif(Pwhite(0.0, 1.0, inf) < 0.7, Pwhite(-7, 0, inf), Pwhite(7, 14, inf)),
	\dur, 0.25
).play;
)
