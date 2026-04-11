// Source: Classes/Psubdivide.schelp block 0 (part 3/4)
(
a = Psubdivide(
	Pseq(#[1,1,1,1,1,2,2,2,2,2,3,3,3,3,3,4,4,4,4,4],inf),
	Pseq(#[0.5, 1, 2, 0.25,0.25],inf)
);
x = a.asStream;

Routine({
	loop({
		Synth.grain(\help_sinegrain, [\freq, 440]);
		x.next.wait;
	})
}).play(TempoClock.default);
)
