// Source: Tutorials/Mark_Polishook_tutorial/Japanese_version/11.schelp block 9 (part 1/4)
(
// 3つのSynthDefとグループを作成する
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
