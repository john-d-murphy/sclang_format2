// Source: Classes/In.schelp block 1 (part 1/7)
(
SynthDef("help-InKr",{ arg out=0, in=0;
	Out.ar(out,
		SinOsc.ar(In.kr(in, 1), 0, 0.1)
	)
}).add;
SynthDef("help-lfo", { arg out=0;
	Out.kr(out, LFNoise1.kr(0.3, 200, 800))
}).add;
)
