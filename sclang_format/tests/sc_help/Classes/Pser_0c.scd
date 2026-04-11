// Source: Classes/Pser.schelp block 0 (part 3/3)
(
a = Pser([Pser(#[60, 61, 63, 65, 72], 3)], inf).asStream;
Routine({
	loop({
		Synth(\help_sinegrain, [\freq, a.next.midicps]);
		0.2.wait;
	})
}).play;
)
