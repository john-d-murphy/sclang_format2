// Source: Classes/In.schelp block 0 (part 2/4)
(
SynthDef("help-PinkNoise", { arg out=0;
	Out.ar(out, PinkNoise.ar(0.1))
}).add;

SynthDef("help-In", { arg out=0, in=0;
	var input;
		input = In.ar(in, 1);
		Out.ar(out, input);

}).add;
)
