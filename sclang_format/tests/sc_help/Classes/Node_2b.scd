// Source: Classes/Node.schelp block 2 (part 2/5)
(
x = SynthDef("help-node-set", { |freq = 440, out = 0|
	Out.ar(out, SinOsc.ar(freq, 0, 0.1))
}).play
)
