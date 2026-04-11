// Source: Guides/UGens-and-Synths.schelp block 1 (part 2/4)
SynthDef.new("FSinOsc-test", { Out.ar(0, FSinOsc.ar(800, 0, 0.2)) }).send(s);
