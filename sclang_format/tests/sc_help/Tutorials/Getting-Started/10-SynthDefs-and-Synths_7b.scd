// Source: Tutorials/Getting-Started/10-SynthDefs-and-Synths.schelp block 7 (part 2/7)
(
SynthDef.new("tutorial-args", { arg freq = 440, out = 0;
	Out.ar(out, SinOsc.ar(freq, 0, 0.2));
}).add;
)
