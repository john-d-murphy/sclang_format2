// Source: Tutorials/Mark_Polishook_tutorial/Japanese_version/12.schelp block 0 (part 3/3)
(
// コンポーネントの再利用の非常にシンプルな例 ...
// \busアーギュメントを使用して、同じSynthDefから作られたシンセを別のチャンネルにアサインする
// この場合には、1チャンネルのサウンド・ファイルを2チャンネルで再生する
// それぞれのチャンネルの再生レートを変えることで効果を明白にする
Synth("aMonoSamplePlayer", [\bus, 0, \bufNum, b, \rateScale, 0.99]);
Synth("aMonoSamplePlayer", [\bus, 1, \bufNum, b, \rateScale, 1.01]);
)
