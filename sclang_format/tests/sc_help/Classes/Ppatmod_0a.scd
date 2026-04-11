// Source: Classes/Ppatmod.schelp block 0 (part 1/3)
(
a = Ppatmod(
	Pseq([0, 0, 0, 0],1),
	{ arg pat, i;
		var list;
		list = pat.list;
		pat.list = list.put(list.size.rand, 2);
	}, inf);

x = a.asStream;
30.do({ x.next.postln });
)
