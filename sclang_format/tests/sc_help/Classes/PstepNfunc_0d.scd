// Source: Classes/PstepNfunc.schelp block 0 (part 4/4)
(
f = { arg vals;
	vals.inject(1, { arg x, y; x * y })
};
x = PstepNfunc(f,
	[
		Pseq([1, 2, 3], inf),
		Pseq([2, pi, 1]),
		Pseq([0.1, 3, 0.2, 3])
	]
	).asStream;

50.do({ x.next.postln });
)
