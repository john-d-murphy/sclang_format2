// Source: Tutorials/Mark_Polishook_tutorial/Japanese_version/04.schelp block 4 (part 1/2)
(
SynthDef("anExample", {
	Out.ar(
		0,
		SinOsc.ar(
			[440, 443] + SinOsc.kr([7, 8], 0, 7), // コントロール・レートはCPUサイクルをセーブする
			0,
			0.2
		)
	)
}).add;
)
