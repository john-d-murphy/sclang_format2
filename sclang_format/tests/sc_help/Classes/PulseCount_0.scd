// Source: Classes/PulseCount.schelp block 0
SynthDef("help-PulseCount",{ arg out=0;
	Out.ar(out,
		SinOsc.ar(
			PulseCount.ar(Impulse.ar(10), Impulse.ar(0.4)) * 200,
			0, 0.05
		)
	)
}).play;
