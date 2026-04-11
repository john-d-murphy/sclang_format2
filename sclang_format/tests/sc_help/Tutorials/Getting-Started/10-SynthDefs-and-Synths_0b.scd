// Source: Tutorials/Getting-Started/10-SynthDefs-and-Synths.schelp block 0 (part 2/2)
SynthDef.new("tutorial-SinOsc", { |out| Out.ar(out, SinOsc.ar(440, 0, 0.2)) }).play;
