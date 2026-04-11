// Source: Classes/Plazy.schelp block 0 (part 3/4)
(
a = Plazy({
	var x, y;
	x = Array.series(rrand(2, 4), [1, 5].choose, 1);
	x.put(x.size.rand, 8+0.1.rand2);
	Pseq(x,1);
});
x = Pn(a, inf).asStream;

Routine({
	loop({
		Synth(\help_sinegrain, [\freq, (x.next*5+70).midicps]);
		0.13.wait;
	})
}).play;
)
