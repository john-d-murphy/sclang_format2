// Source: Classes/Pspawn.schelp block 2 (part 5/8)
(
var	patternChoices = (
	up: { Pbind(\degree, Pseries(rrand(-4, 5), 1, rrand(4, 10)), \dur, 0.125) },
	down: { Pbind(\degree, Pseries(rrand(4, 11), -1, rrand(4, 10)), \dur, 0.125 * 4/3) }
);

p = Pspawn(Pchain(
	Pbind(
		\pattern, Prand([\up, \down], inf),
		\method, \par
	),
	Pbind(
		\delta, Pwhite(1, 5, inf) * 0.125
	)
), (dict: patternChoices)).play;
)
