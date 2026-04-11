// Source: Classes/InTrig.schelp block 0 (part 3/7)
SynthDef("help-InTrig",{arg out=0,busnum=0;
	var inTrig;
	inTrig = InTrig.kr( busnum );
	Out.ar(out,
		EnvGen.kr(Env.perc,gate: inTrig,levelScale: inTrig ) * SinOsc.ar
	)
}).play(s,[\out, 0, \busnum, b.index]);
