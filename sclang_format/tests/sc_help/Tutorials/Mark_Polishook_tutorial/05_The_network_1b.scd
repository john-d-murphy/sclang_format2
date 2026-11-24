// Source: Tutorials/Mark_Polishook_tutorial/05_The_network.schelp block 1 (part 2/4)
SynthDef("sine", { Out.ar(0, SinOsc.ar(440, 0, 0.2)) }).send(s);
