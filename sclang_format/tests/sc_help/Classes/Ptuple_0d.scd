// Source: Classes/Ptuple.schelp block 0 (part 4/4)
(
a = Pseq([73, 71, 69, 69, 65, 64], inf);
b = Pseq([0, 0, 0, 4, 0, 3, 2], inf) + a;
c = Ptuple([a, b], inf);
x = c.asStream;
Routine({
	var chord;
	loop({
		chord = x.next.postln.midicps;
		(instrument: \help_sinegrain, freq: chord).play;
	0.2.wait;
	})
}).play;
)
