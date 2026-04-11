// Source: Guides/UserFAQ.schelp block 1
(
SynthDef(\simplepink, { |out=0|
    Out.ar(out, PinkNoise.ar)
}).add
)
