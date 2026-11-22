// Source: Tutorials/Mark_Polishook_tutorial/15_Groups.schelp block 15 (part 1/5)
(
// build 3 synthdefs and a group
SynthDef("synthNumber1", { arg mul = 0.2;
	Out.ar(
		0,
		BrownNoise.ar(mul) * LFNoise0.kr([1, 1.01])
	)
	}, [0.1]).add;
SynthDef("synthNumber2", { arg mul = 0.2;
	Out.ar(
		0,
		WhiteNoise.ar(mul) * LFNoise1.kr([2.99, 3])
	)
	}, [0.1]).add;
SynthDef("synthNumber3", { arg mul = 0.2;
	Out.ar(
		0,
		PinkNoise.ar(mul) * LFNoise2.kr([0.79, 0.67])
	)
}, [0.1]).add;
)
