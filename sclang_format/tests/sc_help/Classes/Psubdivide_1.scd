// Source: Classes/Psubdivide.schelp block 1
(
a = Psubdivide(
	Pseq(#[1,1,1,1,1,2,2,2,2,2,3,3,3,3,4,4,0,4,4],inf),
	Pseq((80 + [ 0, 2, 3, 5, 7, 9, 10 ]).midicps ,inf)
);
x = a.asStream;
Routine({
	loop({
		Synth.grain(\help_sinegrain, [\freq, x.next.postln]);
		0.25.wait
	})
}).play(TempoClock.default);
)
