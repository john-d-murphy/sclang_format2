// Source: Tutorials/Mark_Polishook_tutorial/Japanese_version/05.schelp block 2 (part 1/2)
(
SynthDef("dataFromABus", {
	Out.ar(
		0,
		[	//　左チャンネルはオーディオ・バスから入力を得る
			In.ar(0, 1),
			SinOsc.ar(440, 0.2),
		]
	)
}).add;
)
