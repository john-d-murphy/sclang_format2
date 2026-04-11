// Source: Tutorials/Mark_Polishook_tutorial/Japanese_version/09.schelp block 3
(
{
	// ミックスしたいUGenを配列の中に入れる
	Mix.ar(
		[
			Saw.ar(500, 0.05),
			Saw.ar(600, 0.06),
			Saw.ar(700, 0.06)
		]
	)
}.scope
)
