// Source: Classes/Scale.schelp block 15 (part 1/17)
(
s.waitForBoot({
	a = Scale.ionian;

	p = Pbind(
		\degree, Pseq([0, 1, 2, 3, 4, 5, 6, 7, 6, 5, 4, 3, 2, 1, 0, \rest], inf),
		\scale, Pfunc({ a }, inf),
		\dur, 0.25
	);

	q = p.play;
})
)
