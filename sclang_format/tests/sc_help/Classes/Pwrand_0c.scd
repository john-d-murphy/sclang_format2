// Source: Classes/Pwrand.schelp block 0 (part 3/3)
(
a = Pwrand([60, 61, 63, 65, 72], [10, 2, 3, 1, 3].normalizeSum, inf).asStream;
Routine({
	loop({
		Synth(\help_sinegrain, [\freq, a.next.midicps]);
		0.1.wait;
	})
}).play;
)
