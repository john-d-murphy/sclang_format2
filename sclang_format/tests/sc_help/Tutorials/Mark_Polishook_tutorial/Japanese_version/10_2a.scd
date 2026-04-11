// Source: Tutorials/Mark_Polishook_tutorial/Japanese_version/10.schelp block 2 (part 1/2)
(
SynthDef("subtractive", {
	Out.ar(
		0,
		LPF.ar(
			Pulse.ar(440, 0.5, 0.1),	// フィルターをかけるソース
			Line.kr(8000, 660, 6)		// フィルターの周波数をLineでコントロールする
		)
	)
}).add;
)
