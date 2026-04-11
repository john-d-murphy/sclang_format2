// Source: Tutorials/Mark_Polishook_tutorial/Japanese_version/12.schelp block 6 (part 3/3)
(
// ソース・グループにサンプル・プレーヤーを追加する
Synth.head(
	~source,
	"aLoopingSamplePlayer", [\outBus, 3, \bufNum, b, \rateScale, 1, \mul, 0.051]);
// エフェクト・グループの先頭に振幅変調シンセを追加する
Synth.head(
	~effect,
	"ampMod", [\inBus, 3, \outBus, 5, \modFreq, 1]);
// エフェクト・グループの最後にフィルタリングを追加する
Synth.tail(
	~effect,
	"aLowPassFilter", [\inBus, 5, \outBus, 0, \boost, 5])
)
