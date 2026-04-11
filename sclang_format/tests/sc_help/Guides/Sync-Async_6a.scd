// Source: Guides/Sync-Async.schelp block 6 (part 1/2)
(
SynthDef("Help-SynthDef", { arg out=0;
	Out.ar(out, PinkNoise.ar(0.1))
}).send(s, ["s_new", "Help-SynthDef", x = s.nextNodeID]);
// this is 'messaging' style, see below
)
