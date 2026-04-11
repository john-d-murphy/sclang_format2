// Source: Classes/PMOsc.schelp block 0 (part 4/4)
(
e = Env.linen(2, 5, 2);
Routine.run({
	loop({
		play({
			LinPan2.ar(EnvGen.ar(e) *
				PMOsc.ar(2000.0.rand,800.0.rand, Line.kr(0.0, 12.0.rand,9),0,0.1), 1.0.rand2)});
		2.wait;
	})
}))
