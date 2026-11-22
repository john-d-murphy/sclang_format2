// Source: Guides/Non-Realtime-Synthesis.schelp block 8 (part 1/2)
(
SynthDef(\NRTsine, { |out, freq = 440|
	Out.ar(out, SinOsc.ar(freq, 0, 0.2).dup)
}).add;
)
