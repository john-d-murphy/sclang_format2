// Source: Classes/Pswitch1.schelp block 0 (part 3/3)
(
a = Pseq([73, 71, 69], inf);
b = Pseq([0, 0, 0, 4, 0]+64, inf);
c = Pswitch1([a, b, 75], Pseq([2, 2, 0, 1], inf));
x = c.asStream;
Routine({
	loop({
		Synth(\help_sinegrain, [\freq, x.next.midicps]);
		0.18.wait;
	})
}).play;
)
