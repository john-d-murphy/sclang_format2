// Source: Tutorials/Getting-Started/10-SynthDefs-and-Synths.schelp block 2 (part 2/4)
y = SynthDef.new("tutorial-SinOsc", { |out| Out.ar(out, SinOsc.ar(440, 0, 0.2)) }).play;
