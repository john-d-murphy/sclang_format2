// Source: Classes/InFeedback.schelp block 1 (part 1/9)
(
SynthDef("help-InFeedback", { arg out=0, in=0;
	Out.ar(out,
		InFeedback.ar(in, 1)
	);
}).add;
SynthDef("help-SinOsc", { arg out=0, freq=440;
	Out.ar(out, SinOsc.ar(freq, 0, 0.1))
}).add;
)
