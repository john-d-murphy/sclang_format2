// Source: Classes/Pstutter.schelp block 1 (part 4/10)
(
c = Pstutter(3, Pxrand([1, 2, 3], inf) * 4 + 65);
x = c.asStream;
Routine {
	loop {
		Synth(\help_sinegrain, [\freq, x.next.midicps]);
		0.12.wait;
	}
}.play;
)
