// Source: Guides/Tracing-Processes.schelp block 9
Pbind(
	\degree, Pseq([1, 4, 1, Pwhite(0, 6, 3), 100, 39], inf).trace(prefix: "value: "),
	\dur, 0.2
).play
