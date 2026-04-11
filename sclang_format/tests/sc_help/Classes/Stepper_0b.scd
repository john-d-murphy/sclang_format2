// Source: Classes/Stepper.schelp block 0 (part 2/16)
SynthDef("help-Stepper",{ arg out=0;
	Out.ar(out,
		SinOsc.ar(
			Stepper.kr(Impulse.kr(10), 0, 4, 16, -3) * 100,
			0, 0.05
		)
	)
}).play;
