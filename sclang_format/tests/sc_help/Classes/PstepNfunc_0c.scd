// Source: Classes/PstepNfunc.schelp block 0 (part 3/4)
(
f = { arg vals;
	vals.postln;
};
x = PstepNfunc(f, [Pseq([1, 2, 3]), Pseq([10, 20, 30, 40]), Pseq([100, 200, 300], inf)]).asStream;
50.do({ x.next });
)
