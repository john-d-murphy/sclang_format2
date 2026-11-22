// Source: Classes/Pspawn.schelp block 2 (part 7/8)
(
var	patternChoices = (
	up: { Pbind(\degree, Pseries(rrand(-4, 5), 1, rrand(4, 10)), \dur, 0.125) },
	down: { Pbind(\degree, Pseries(rrand(4, 11), -1, rrand(4, 10)), \dur, 0.125 * 4/3) }
);

p = Ppar([
	Pspawn(Pbind(
			// intermediate value
		\patternKey, Prand([\up, \down], inf),
			// pattern is selected and pan applied here
		\pattern, Pfunc { |ev| Pbindf(ev.dict[ev.patternKey].value, \pan, -1) },
		\delta, Pwhite(1, 5, inf) * 0.125,
		\method, \par
	), (dict: patternChoices)),
	Pspawn(Pbind(
		\patternKey, Prand([\up, \down], inf),
		\pattern, Pfunc { |ev| Pbindf(ev.dict[ev.patternKey].value, \pan, 1) },
		\delta, Pwhite(1, 5, inf) * 0.125,
		\method, \seq
	), (dict: patternChoices)),
]).play;
)
