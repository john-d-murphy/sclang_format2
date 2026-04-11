// Source: Tutorials/Mark_Polishook_tutorial/Japanese_version/09.schelp block 6
(
	// ... 汽車のまね？
	{
		(WhiteNoise.ar(0.1) * SinOsc.kr(1, 1))
		+
		(BrownNoise.ar(0.1) * SinOsc.kr(2, 1))
	}.scope;
)
