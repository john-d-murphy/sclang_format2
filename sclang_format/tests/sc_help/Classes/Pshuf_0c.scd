// Source: Classes/Pshuf.schelp block 0 (part 3/3)
(
a = Pn(Pshuf(#[60, 60, 60, 61, 63, 65, 72], 4), inf).asStream;
Routine({
	loop({
	Synth(\help_sinegrain, [\freq, a.next.midicps]);
	0.15.wait;
	})
}).play;
)
