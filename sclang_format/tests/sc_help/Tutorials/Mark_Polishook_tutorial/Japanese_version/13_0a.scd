// Source: Tutorials/Mark_Polishook_tutorial/Japanese_version/13.schelp block 0 (part 1/4)
(
SynthDef("someGrains", { arg centerFreq = 777, freqDev = 200, grainFreq = 2;
	var gate;
	gate = Impulse.kr(grainFreq);
	Out.ar(
		0,
		SinOsc.ar(
			LFNoise0.kr(4, freqDev, centerFreq),
			0,
			EnvGen.kr(Env.sine(0.1), gate, 0.1)
		)
	)
}).add;

SynthDef("aDelay", { arg delay = 0.25;
	Out.ar(
		1,
		DelayN.ar(
			In.ar(0, 1),
			delay,
			delay
		)
	)
}).add;
)
