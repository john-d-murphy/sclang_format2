// Source: Classes/Psym.schelp block 0 (part 11/15)
(
Pdef(\play, Psym(
	Prand([
		Pseq([[\x, \y], \z], 5),
		Pseq([[\z, \y], \x, \x, \y])
		]
	, inf).trace)
).play
);
