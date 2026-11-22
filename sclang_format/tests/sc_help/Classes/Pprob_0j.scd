// Source: Classes/Pprob.schelp block 0 (part 10/16)
(
var t;
a = Pprob([0, 0, 1, 0, 1, 1, 0, 0], 60, 80);
t = a.asStream;
Routine({
	loop({
	Synth(\help_sinegrain, [\freq, t.next.midicps]);
	0.01.wait;
	})
}).play;
)
