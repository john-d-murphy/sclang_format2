// Source: Classes/Linen.schelp block 0 (part 7/8)
(
// debussey sleeping through math class
x = Pbrown(0.01, 2.0, 0.2, inf).asStream;
Routine({
	loop({
		Synth.grain("help-Linen",[\freq, (rrand(20, 50) * 2).midicps, \releaseTime, x.next]);
		0.25.wait;
	})
}).play(TempoClock.default)
)
