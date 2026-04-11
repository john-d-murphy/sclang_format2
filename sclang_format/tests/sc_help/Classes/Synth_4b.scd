// Source: Classes/Synth.schelp block 4 (part 2/6)
(
SynthDef("help-Synth-get", { | out, freq = 440|
	Out.ar(out, SinOsc.ar(freq, 0, 0.1));
}).add;
)
