// Source: Classes/Pgbrown.schelp block 0 (part 3/4)
(
var a;
a = Pgbrown(1.0, 2.0, 0.1, inf).asStream;
Routine({
	loop({
	Synth(\help_sinegrain, [\freq, a.next * 600 + 300]);
	0.02.wait;
	})
}).play;
)
