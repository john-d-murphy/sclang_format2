// Source: Classes/PdegreeToKey.schelp block 0 (part 2/2)
(
var scales;
scales = #[[0, 2, 3, 6, 7, 9], [0, 1, 5, 6, 7, 9, 11], [0, 2, 3]];
Pbind(\note, PdegreeToKey(
			Pseq([1, 2, 3, 2, 5, 4, 3, 4, 2, 1], 4),
			Pdup(3, Prand(scales, inf)),
			12
		),
	\dur, 0.25
).play;
)
