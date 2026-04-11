// Source: Guides/Polymorphism.schelp block 9
(
x = SynthDef("Help-SynthDef", { arg out=0;
    Out.ar(out, PinkNoise.ar(0.1))
}).play;
)
