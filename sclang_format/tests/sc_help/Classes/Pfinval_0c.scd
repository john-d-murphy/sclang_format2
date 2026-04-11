// Source: Classes/Pfinval.schelp block 0 (part 3/3)
(
var c, b;
c = Pn(Pfinval({ rrand(3, 5)}, Pseq([1, 2, 3, 4, 5, 6],inf)*4+65),inf);
b = c.asStream;
Routine({
	loop({
		Synth(\help_sinegrain, [\freq, b.next.midicps]);
		0.12.wait;
	})
}).play;
)
