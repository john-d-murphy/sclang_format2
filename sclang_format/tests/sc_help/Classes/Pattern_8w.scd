// Source: Classes/Pattern.schelp block 8 (part 23/27)
Pbind(\degree, Ptuple([Pwhite(1, -6), Pbrown(8, 15, 2)]),
	\dur, Pfunc({ |ev| ev.at(\degree).last/80 round: 0.1 }),
	\db, Pfunc({ if (coin(0.8)) { -25 } { -20 } })
).play
