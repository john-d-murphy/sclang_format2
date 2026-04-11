// Source: Classes/Ppatlace.schelp block 1 (part 2/3)
(
var c = Ppatlace([
		Pseq([0, 0, 0, 0, 8, 0, 8], inf),
		Pseries(1, 1, 32)
	], inf) + 67;
x = c.asStream;

Routine({
	loop({
		Synth(\help_sinegrain, [\freq, x.next.midicps, \dur, 0.2]);
		0.17.wait;
	})
}).play;
)
