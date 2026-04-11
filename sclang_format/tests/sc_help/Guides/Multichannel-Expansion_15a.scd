// Source: Guides/Multichannel-Expansion.schelp block 15 (part 1/2)
(
SynthDef(\help_multichannel, { |out=0, freq=#[342, 145]|
	var env = EnvGate.new;
	Out.ar(out, [SinOsc.ar(freq[0]), Saw.ar(freq[1])] * env * 0.2)
}).add
)
