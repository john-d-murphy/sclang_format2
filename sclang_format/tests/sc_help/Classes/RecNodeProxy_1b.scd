// Source: Classes/RecNodeProxy.schelp block 1 (part 2/10)
SynthDef("test", { arg out; Out.ar(out, { WhiteNoise.ar(0.1) }.dup(2)) }).add;
