// Source: Classes/Dust.schelp block 0 (part 1/2)
(
SynthDef("help-Dust", { arg out=0;
	Out.ar(out,
		Dust.ar(200, 0.5)
	)
}).play;
)
