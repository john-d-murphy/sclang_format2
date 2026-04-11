// Source: Classes/XOut.schelp block 1 (part 1/6)
(
SynthDef("help-SinOsc", { arg freq=440, out;
	Out.ar(out, SinOsc.ar(freq, 0, 0.1))
}).add;

SynthDef("help-XOut", { arg out=0, xFade=1;
	var source;
		source = PinkNoise.ar(0.05);

		// write to the bus, crossfading with previous contents
		XOut.ar(out, xFade, source);

}).add;
)
