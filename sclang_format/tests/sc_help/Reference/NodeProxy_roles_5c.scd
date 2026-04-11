// Source: Reference/NodeProxy_roles.schelp block 5 (part 3/4)
(
a[0] = \setsrc -> Pbind(
	\dur, Prand([1, 0.5, 2], inf),
	\source, Prand ([
		{ SinOsc.ar(SinOsc.ar({5.rand}.dup + 4) * 50 + 400 + 50.rand) * 0.1 },
		{ SinOsc.ar(LFSaw.ar({5.rand}.dup + 4) * 50 + 400 + 50.rand) * 0.1},
		{ LFSaw.ar(SinOsc.ar({5.rand}.dup + 4) * 50 + 400 + 50.rand) * 0.1 },
		{ LFSaw.ar(LFSaw.ar({5.rand}.dup + 4) * 50 + 400 + 50.rand) * 0.1 }
	], inf)
)
);
