// Source: Classes/SynthDesc.schelp block 9 (part 3/4)
a = SynthDef(\x, { |out, freq = 440| Out.ar(out + 7, SinOsc.ar(freq)) }).add;
