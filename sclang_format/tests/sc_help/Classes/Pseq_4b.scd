// Source: Classes/Pseq.schelp block 4 (part 2/2)
(
a = Pseq(#[60, 61, 63, 65, 72], inf).asStream;
Routine({
	loop({
		Synth(\help_sinegrain, [\freq, a.next.midicps]);
		0.2.wait;
	})
}).play;
)
