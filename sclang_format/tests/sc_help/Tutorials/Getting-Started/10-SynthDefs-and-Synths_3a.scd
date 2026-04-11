// Source: Tutorials/Getting-Started/10-SynthDefs-and-Synths.schelp block 3 (part 1/5)
SynthDef.new("tutorial-PinkNoise", { |out| Out.ar(out, PinkNoise.ar(0.3)) }).add;
