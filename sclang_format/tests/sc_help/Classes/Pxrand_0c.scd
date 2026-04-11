// Source: Classes/Pxrand.schelp block 0 (part 3/3)
(
a = Pxrand(#[60, 61, 63, 65, 72], inf).asStream;
Routine({
	loop({
		Synth(\help_sinegrain, [\freq, a.next.midicps]);
		0.1.wait;
	})
}).play;
)
