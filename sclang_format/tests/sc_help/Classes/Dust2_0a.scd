// Source: Classes/Dust2.schelp block 0 (part 1/2)
(
SynthDef("help-Dust2", { arg out=0;
	Out.ar(out,
		Dust2.ar(200, 0.5)
	)
}).play;
)
