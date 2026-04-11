// Source: Classes/Pclutch.schelp block 0 (part 3/3)
(
var a;
a = Pclutch(
		Pseq([1, 2, 3, 4, 5], inf),
		Pseq([0, 0, 1, 0, Pn(0, {30.rand}), 0, 1, 1], inf)
	).asStream;
{
	loop {
		Synth(\help_sinegrain, [\freq, a.next * 200 + 200]);
		0.02.wait;
	}
}.fork;
)
