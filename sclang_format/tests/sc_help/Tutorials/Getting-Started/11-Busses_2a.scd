// Source: Tutorials/Getting-Started/11-Busses.schelp block 2 (part 1/3)
(
SynthDef("tutorial-args", { arg freq = 440, out = 0;
	Out.ar(out, SinOsc.ar(freq, 0, 0.2));
}).add;
)
