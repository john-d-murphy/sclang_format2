// Source: Tutorials/Mark_Polishook_tutorial/Japanese_version/09.schelp block 11
(
{	var n = 12;

	Mix.arFill(
			n,						// n個のサイン波を生成する
			{
			SinOsc.ar(					// それぞれがlow.rrand(high)の範囲内で起こりうる周波数
				[67.0.rrand(2000), 67.0.rrand(2000)],	// ... 実数の値
				0,
				n.reciprocal				// それぞれのサイン波の振幅をスケーリングする
									// nの値に従って
			)
			*
			EnvGen.kr(					// サイン波のそれぞれにエンベロープを与える
				Env.sine(2.0.rrand(17)),
				doneAction: Done.none 				// サウンド全体が完了した時にだけ
									// エンベロープを解放する（なぜ？）
			)
		}
	)
	*								// パッチ全体に対してエンベロープを与える
	EnvGen.kr(
		Env.perc(11, 6),
		doneAction: Done.freeSelf,
		levelScale: 0.75
	)

}.scope
)
