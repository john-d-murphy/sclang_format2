// Source: Tutorials/A-Practical-Guide/PG_04_Words_to_Phrases.schelp block 6 (part 1/2)
(
p = Pbind(
	\degree, Pswitch([Pwhite(7, 14, inf), Pwhite(-7, 0, inf)], Pfunc { 0.7.coin.binaryValue }),
	\dur, 0.25
).play;
)
