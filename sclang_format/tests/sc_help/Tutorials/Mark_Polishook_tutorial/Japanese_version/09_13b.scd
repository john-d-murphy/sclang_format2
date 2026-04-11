// Source: Tutorials/Mark_Polishook_tutorial/Japanese_version/09.schelp block 13 (part 2/2)
(
	{
		SinOsc.ar(440, 0, 0.571)
		*
		(SinOsc.kr(880).abs			// モジュレータとlfoを括弧の中に包み込む
		* 					// なぜ？
		SinOsc.kr([6.99, 8.01].reciprocal)
		)
	}.scope
)
