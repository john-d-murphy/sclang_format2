// Source: Classes/Synth.schelp block 1 (part 5/10)
(
SynthDef("help-synth", {| freq = #[440, 450, 460], out = 0 |
	Out.ar(out, Mix(SinOsc.ar(freq, 0, 0.1)));
}).add;
)
