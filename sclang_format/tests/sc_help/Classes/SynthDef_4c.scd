// Source: Classes/SynthDef.schelp block 4 (part 3/11)
d = SynthDef(\SimpleSine, { |freq = 440, out| Out.ar(out, SinOsc.ar(freq, 0, 0.2)) });
