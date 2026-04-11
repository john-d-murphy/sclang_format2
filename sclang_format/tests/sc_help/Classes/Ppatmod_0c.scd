// Source: Classes/Ppatmod.schelp block 0 (part 3/3)
(
a = Pn(
	Ppatmod(
		Pseq([0, 0, 0, 0],1),
		{ arg pat, i;
			var list;
			list = pat.list;
			pat.list = list.put(list.size.rand, 2);
		}, 15),
inf).asStream;

Routine({
	loop({
		Synth(\help_sinegrain, [\freq, (a.next*5+77).midicps]);
		0.13.wait;
	})
}).play;
)
