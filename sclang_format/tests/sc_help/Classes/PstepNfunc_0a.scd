// Source: Classes/PstepNfunc.schelp block 0 (part 1/4)
(
f = { arg vals;
	vals.postln;
};
x = PstepNfunc(f, [
		Pseq([1, 2, 3]), Pseq([4, 5, 6]), Pseq([7, 8, 9])
	]).asStream;
50.do({ x.next });
)
