// Source: Guides/Sync-Async.schelp block 3
(
var name;
name = "Rand-SynthDef" ++ 400.0.rand;

SynthDef(name, { arg out = 0;
	Out.ar(out, PinkNoise.ar(0.1))
}).send(s);

SystemClock.sched(0.05, {Synth.new(name, s);}); // create a Synth after 0.05 seconds
)
