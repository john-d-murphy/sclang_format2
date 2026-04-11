// Source: Guides/UserFAQ.schelp block 2
(
(1..5).do{ |n|
SynthDef("simplepink_%".format(n).asSymbol, { |out=0|
    Out.ar(out, {PinkNoise.ar}.dup(n))
}).add
}
)
