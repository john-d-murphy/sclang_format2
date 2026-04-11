// Source: Classes/Plazy.schelp block 0 (part 1/4)
(
a = Plazy({
	var x, y;
	x = Array.series(rrand(2, 4), [1, 100].choose, 1);
	Pshuf(x,1);
});
x = Pn(a, inf).asStream;
30.do({ x.next.postln });
)
