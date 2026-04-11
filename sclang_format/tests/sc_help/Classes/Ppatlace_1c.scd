// Source: Classes/Ppatlace.schelp block 1 (part 3/3)
(
c = Ppatlace([
	Pxrand([
		Pseq(#[0, -2, -3, -5, -7], 1), Pwhite(-12, 4, 3), Pshuf(#[0, -2, -3, -5, -7], 1)
	], inf),
	Pxrand([
		Pseq(#[0, 2, 4, 5, 7], 1), Pwhite(-4, 12, 3), Pshuf(#[0, 2, 4, 5, 7], 1)
	], inf)
], inf) + 67;
x = c.asStream;

Routine({
	loop({
		Synth(\help_sinegrain, [\freq, x.next.midicps, \dur, 0.2]);
		0.17.wait;
	})
}).play;
)
