// Source: Classes/EnvGen.schelp block 9 (part 2/9)
(
SynthDef(\sine, { |out, freq = 440|
	Out.ar(out, SinOsc.ar(freq, 0, 0.2));
}).add;
)
