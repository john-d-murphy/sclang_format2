// Source: Classes/ReplaceOut.schelp block 0 (part 1/7)
(
SynthDef("ReplaceOutHelp", { arg out=0, freq=440;
	var source;
		source = SinOsc.ar(freq, 0, 0.1);

		// write to the bus, replacing previous contents
		ReplaceOut.ar(out, source);

}).add;
)
