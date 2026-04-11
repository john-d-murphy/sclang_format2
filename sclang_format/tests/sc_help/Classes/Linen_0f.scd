// Source: Classes/Linen.schelp block 0 (part 6/8)
(
SynthDef("help-Linen",{ arg out=0,freq=440,attackTime=0.01,susLevel=0.6,releaseTime=0.1;
	Out.ar(out,
		Linen.kr(Impulse.kr(0), attackTime, susLevel, releaseTime, doneAction: Done.freeSelf)
			* SinOsc.ar(freq, 0, 0.1)
	)
}).add;
)
