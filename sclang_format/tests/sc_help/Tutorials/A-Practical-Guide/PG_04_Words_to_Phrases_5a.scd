// Source: Tutorials/A-Practical-Guide/PG_04_Words_to_Phrases.schelp block 5 (part 1/2)
(
TempoClock.default.tempo = 1;
p = Pbind(
	\degree, Pswitch1([Pwhite(7, 14, inf), Pwhite(-7, 0, inf)], Pfunc { 0.7.coin.binaryValue }),
	\dur, 0.25
).play;
)
