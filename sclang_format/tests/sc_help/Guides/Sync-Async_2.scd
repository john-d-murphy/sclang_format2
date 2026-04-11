// Source: Guides/Sync-Async.schelp block 2
(
var name;
name = "Rand-SynthDef" ++ 400.0.rand; // use a random name to ensure it's not already loaded

SynthDef(name, { arg out=0;
	Out.ar(out, PinkNoise.ar(0.1))
}).send(s);

Synth.new(name, s);
)
