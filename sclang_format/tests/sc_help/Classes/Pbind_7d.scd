// Source: Classes/Pbind.schelp block 7 (part 4/4)
Pbind(
	[\freq, \sustain], Ptuple([
                          Pseq((1..16) * 50, 4),
                          Pseq([1/10, 0.5, 1, 2], inf)
				       ]),
	instrument:        \test,
	nharms:            Pseq([4, 10, 40], inf),
	dur:			   Pseq([1, 1, 2, 1]/10, inf),
).play
