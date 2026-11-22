// Source: Tutorials/JITLib/proxyspace_examples.schelp block 14 (part 3/15)
~out = SynthDef("w", { arg out=0; Out.ar(out,SinOsc.ar([Rand(430, 600), 500], 0, 0.2)) });
