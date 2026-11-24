// Source: Guides/Backwards-Compatibility.schelp block 2 (part 6/10)
x = SynthDef("backcompat-sine", { arg freq = 440; Out.ar(1, SinOsc.ar(freq, 0, 0.5)) }).play;
