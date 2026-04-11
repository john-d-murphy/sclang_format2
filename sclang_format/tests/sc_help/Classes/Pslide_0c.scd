// Source: Classes/Pslide.schelp block 0 (part 3/3)
(
c = Pslide(#[1, 2, 3, 4, 5], inf, 3, 1, 0) * 3 + 67;
x = c.asStream;
Routine({
	loop({
		Synth(\help_sinegrain, [\freq, x.next.midicps]);
		0.17.wait;
	})
}).play;
)
