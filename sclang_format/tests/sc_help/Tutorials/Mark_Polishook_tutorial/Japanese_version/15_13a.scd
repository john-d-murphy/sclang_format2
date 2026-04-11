// Source: Tutorials/Mark_Polishook_tutorial/Japanese_version/15.schelp block 13 (part 1/2)
(
SynthDef("echoplex", {
	ReplaceOut.ar(
		0,
		CombN.ar(
			In.ar(0, 1),
			0.35,
			[Rand(0.05, 0.3), Rand(0.05, 0.3)],
			// シンセが生成されるたびにランダムな値を生成する
			7,
			0.5
		)
	)
}).add;

// ~sourceグループをルートノードの先頭に追加し、~effectsグループをる−とノードの最後に追加する
~source = Group.head(s);
~effect = Group.tail(s);

r = Routine({

	// ループはinf.doと同じ。例えば、永遠に実行される無限ループを生成する。
	loop({
		Synth.head(	// ~sourceグループの先頭にシンセを追加する
			~source,
			"fm2",
			[
				\outbus, 0, \freq, 400.0.rrand(1200), \modPartial, 0.3.rrand(2.0),
				\carPartial, 0.5.rrand(11), \ts, 0.1.rrand(0.2)]
		);
		2.wait;
	})
});
// 2つのechoplexesーこれらを~effectsグループの先頭に順に追加する
Synth.head(~effect, "echoplex");
Synth.head(~effect, "echoplex");
)
