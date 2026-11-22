// Source: Tutorials/A-Practical-Guide/PG_04_Words_to_Phrases.schelp block 2 (part 1/2)
(
var	n = 10,
	scaleSegments = Array.fill(n, { |i|
		if(i.odd) {
			Pseries(11, -1, rrand(5, 10))
		} {
			Pseries(rrand(-4, 4), 1, i+2)
		}
	});

TempoClock.default.tempo = 1;
p = Pbind(
	\degree, Pswitch(scaleSegments, Pseq([Pwhite(0, n-1, 4), Pwhite(0, n-1, 1).select(_.odd)], inf)),
	\dur, 0.125
).play;
)
