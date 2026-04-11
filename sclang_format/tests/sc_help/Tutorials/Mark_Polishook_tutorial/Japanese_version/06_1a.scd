// Source: Tutorials/Mark_Polishook_tutorial/Japanese_version/06.schelp block 1 (part 1/2)
(
// デフォルト値を持つ2つのアーギュメント
SynthDef("withControls", { arg freq = 440, mul = 0.22;
	Out.ar(
		0,
		SinOsc.ar([freq, freq+1], 0, mul)
	)
}).add;
)
