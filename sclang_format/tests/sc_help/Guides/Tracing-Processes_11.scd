// Source: Guides/Tracing-Processes.schelp block 11
Pbind(
	\degree, Pseq([1, 4, 1, Pwhite(0, 6, 3), 100, 39], inf),
	\dur, Pwhite(0.2, 0.4, inf)
).trace([\degree, \dur], prefix: ["degree ", "dur "]).play
