// Source: Classes/Pwalk.schelp block 0 (part 1/9)
(
a = Pwalk(
	Array.series(20, 0, 1),		// integers, 0-19
		// steps up to 2 in either direction, weighted toward positive
	Pwrand([-2, -1, 0, 1, 2], [0.05, 0.1, 0.15, 1, 0.1].normalizeSum, inf),
		// reverse direction at boundaries
	Pseq([1, -1], inf),
	10);	// start in the middle
x = a.asStream;
)
