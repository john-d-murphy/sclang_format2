// Source: Guides/UserFAQ.schelp block 0
(
SynthDef(\thiswillfail, { |out=0, numChannels=2|
    Out.ar(out, {PinkNoise.ar}.dup(numChannels))
}).add
)
