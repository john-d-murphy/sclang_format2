// Source: Classes/RandID.schelp block 0 (part 1/6)
(
SynthDef("help-RandID", { arg out=0, id=1;
	RandID.ir(id);
	Out.ar(out,
		WhiteNoise.ar(0.05) + Dust2.ar(70)
	)
}).add;
)
