// Source: Classes/DynKlang.schelp block 0 (part 2/6)
(
fork {
	loop {
		play {
			var mod = SinOsc.kr(Rand(0.1, 0.9), 0, Rand(5, 20));
			Pan2.ar(DynKlang.ar(`[ Array.rand(12, 200.0, 2000.0), 1, mod ]), 1.0.rand)
				* EnvGen.kr(Env.sine(4), 1, 0.02, doneAction: Done.freeSelf)
		};
		2.wait;
	}
}
)
