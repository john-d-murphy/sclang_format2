// Source: Classes/PstepNfunc.schelp block 0 (part 2/4)
(
f = { arg vals;
	var r;
	r = vals.copy.removeAt(0);
	vals.do({ arg item;  r = item / r.squared * 10 });
	r
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
