// Source: Tutorials/Mark_Polishook_tutorial/Japanese_version/09.schelp block 2
(
{
	// 最初の2つのUGenは1つのBinaryOpUGenに合体する
	Saw.ar(500, 0.05)
	+
	Saw.ar(600, 0.06)
	+
	// このUGenはBinaryOpUGenに対するオペランドと‘+’オペレータ
	Saw.ar(700, 0.07)
}.scope;
)
