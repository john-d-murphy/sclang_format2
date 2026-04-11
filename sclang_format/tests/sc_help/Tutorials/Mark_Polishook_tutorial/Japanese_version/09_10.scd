// Source: Tutorials/Mark_Polishook_tutorial/Japanese_version/09.schelp block 10
(
{	// 関数を12回実行する
	var n = 12;
	Mix.arFill(
		n,
		{
			SinOsc.ar(
				[67.0.rrand(2000), 67.0.rrand(2000)],
				0,
				n.reciprocal * 0.75
			)
		}
	)
	*
	EnvGen.kr(Env.perc(11, 6), doneAction: Done.freeSelf)
}.scope
)
