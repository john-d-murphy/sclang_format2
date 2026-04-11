// Source: Tutorials/Getting-Started/10-SynthDefs-and-Synths.schelp block 5 (part 1/7)
SynthDef("tutorial-Rand", { |out| Out.ar(out, SinOsc.ar(Rand(440, 660), 0, 0.2)) }).add;
