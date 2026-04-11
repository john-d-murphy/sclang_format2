// Source: Classes/Prand.schelp block 0 (part 4/4)
(
a = Prand(#[60, 61, 63, 65, 72], inf).asStream;
Routine({
	loop({
		Synth(\help_sinegrain, [\freq, a.next.midicps]);
		0.2.wait;
	})
}).play;
)
