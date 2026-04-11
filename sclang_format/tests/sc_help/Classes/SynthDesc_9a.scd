// Source: Classes/SynthDesc.schelp block 9 (part 1/4)
a = SynthDef(\x, { |out, freq = 440| Out.ar(out, SinOsc.ar(freq)) }).add;
