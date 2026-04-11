// Source: Classes/Stepper.schelp block 0 (part 3/16)
SynthDef("help-Stepper",{ arg out=0;
	Out.ar(out,
		SinOsc.ar(
			Stepper.kr(Impulse.kr(10), 0, 4, 16, 4) * 100,
			0, 0.05
		)
	)
}).play;
