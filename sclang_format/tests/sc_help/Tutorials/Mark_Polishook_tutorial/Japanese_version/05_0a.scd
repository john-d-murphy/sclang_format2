// Source: Tutorials/Mark_Polishook_tutorial/Japanese_version/05.schelp block 0 (part 1/2)
(
SynthDef("dataForABus", {
	Out.ar(
		0,		// 1チャンネル分のオーディオをバス0に書き込む
		Saw.ar(100, 0.1)
	)
}).add;
)
