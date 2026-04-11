// Source: Tutorials/Mark_Polishook_tutorial/Japanese_version/09.schelp block 1
(
	// 2つのノコギリ波をミックスする
	{
		Saw.ar(500, 0.05)	// オブジェクト
		+			// オペレータ
		Saw.ar(600, 0.06)	// オペランド
	}.scope;
)
