// Source: Classes/Dust.schelp block 0 (part 2/2)
(
SynthDef("help-Dust", { arg out=0;
	Out.ar(out,
		Dust.ar(XLine.kr(20000, 2, 10), 0.5)
	)
}).play;
)
