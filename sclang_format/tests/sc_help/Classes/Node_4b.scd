// Source: Classes/Node.schelp block 4 (part 2/6)
(
x = SynthDef("help-node-set", { |freq = #[440, 450, 460], out = 0|
	Out.ar(out, Mix(SinOsc.ar(freq, 0, 0.1)))
}).play
)
