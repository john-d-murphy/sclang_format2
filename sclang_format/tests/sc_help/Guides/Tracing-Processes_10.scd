// Source: Guides/Tracing-Processes.schelp block 10
Pbind(
	\degree, Pseq([1, 4, 1, Pwhite(0, 6, 3), 100, 39], inf),
	\dur, 0.2
).trace(\degree).play
