// Source: Classes/NodeProxy.schelp block 17 (part 8/70)
a.source = SynthDef("w", { arg out=0; Out.ar(out,SinOsc.ar([Rand(430, 600), 600], 0, 0.2)) });
