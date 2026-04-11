// Source: Tutorials/Mark_Polishook_tutorial/Japanese_version/13.schelp block 2
(
{
var s, z, y;
	// ランダムな10ボイス分のサイン波のパーカッション・サウンド：
s = Mix.ar(Array.fill(10, { Resonz.ar(Dust.ar(0.2, 50), 200 + 3000.0.rand, 0.003)}) );
	// リバーブのプリ・ディレイ・タイム：
z = DelayN.ar(s, 0.048);
	// 並列に7つの長さを変調されたcombによるディレイ：
y = Mix.ar(Array.fill(7,{ CombL.ar(z, 0.1, LFNoise1.kr(0.1.rand, 0.04, 0.05), 15) }));
	// 4つのallpassによるディレイの２つの並列したチェーン（合計8個）：
4.do({ y = AllpassN.ar(y, 0.050, [0.050.rand, 0.050.rand], 1) });
	// オリジナルのサウンドをリバーブに加えてそれを再生：
s+(0.2*y)
}.scope
)
