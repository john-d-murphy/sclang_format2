// Source: Classes/Out.schelp block 0 (part 1/4)
(
SynthDef("help-out", { arg out=0, freq=440;
	var source;
		source = SinOsc.ar(freq, 0, 0.1);

		// write to the bus, adding to previous contents
		Out.ar(out, source);

}).add;
)
