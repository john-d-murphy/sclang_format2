// Source: Guides/Sync-Async.schelp block 7 (part 1/2)
(
SynthDef("Help-SynthDef", { arg out=0;
	Out.ar(out, PinkNoise.ar(0.1))
}).send(s, {x = Synth.basicNew("Help-SynthDef"); x.newMsg; }.value); // 'object' style
)
