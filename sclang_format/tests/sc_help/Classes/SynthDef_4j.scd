// Source: Classes/SynthDef.schelp block 4 (part 10/11)
x = SynthDef(\SimpleSine, { |freq = 440, out| Out.ar(out, SinOsc.ar(freq, 0, 0.2)) }).play
