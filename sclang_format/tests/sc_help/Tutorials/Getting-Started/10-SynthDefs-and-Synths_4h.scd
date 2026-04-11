// Source: Tutorials/Getting-Started/10-SynthDefs-and-Synths.schelp block 4 (part 8/14)
SynthDef("tutorial-NoRand", { |out| Out.ar(out, SinOsc.ar(440 + 200.rand, 0, 0.2)) }).add;
