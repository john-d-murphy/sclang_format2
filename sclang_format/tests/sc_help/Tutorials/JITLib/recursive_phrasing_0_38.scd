// Source: Tutorials/JITLib/recursive_phrasing.schelp block 0 (part 39/45)
(
Pdef(\koch, { arg dur=1, degree=0;
	Pbind(
		\dur, dur.value / 3,
		\degree, degree + Pseq([0, 2, 0])
	)
});
)
