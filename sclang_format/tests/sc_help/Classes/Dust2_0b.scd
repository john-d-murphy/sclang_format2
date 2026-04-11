// Source: Classes/Dust2.schelp block 0 (part 2/2)
(
SynthDef("help-Dust2", { arg out=0;
	Out.ar(out,
		Dust2.ar(XLine.kr(20000, 2, 10), 0.5)
	)
}).play;
)
