// Source: Classes/Pwalk.schelp block 0 (part 7/9)
(
a = Pwalk(
	[60, 64, 67, 72, 76, 79, 84].midicps,	// C major
	Pseq([1], inf),
	Pseq([1, -1], inf),	// turn around at either end
	0);
x = a.asStream;

SynthDef(\help_walk, { |out, freq|
	Out.ar(out, Saw.ar([freq, freq+1], 0.5) * EnvGen.kr(Env.perc(0.01, 0.1), doneAction: Done.freeSelf))
}).add;
)
