// Source: Classes/RandID.schelp block 0 (part 2/6)
(
SynthDef("help-RandSeed", { arg seed=1910, id=1;
		RandID.kr(id);
		RandSeed.kr(Impulse.kr(FSinOsc.kr(0.2, 0, 10, 11)), seed);
}).add;

)
