// Source: Tutorials/Mark_Polishook_tutorial/Japanese_version/12.schelp block 6 (part 1/3)
(
// サウンド・ファイルを読み込む
b = Buffer.read(s, Platform.resourceDir +/+ "sounds/a11wlk01.wav");

// サウンド・ファイル全体をループ再生するサンプル・プレーヤーを定義する
SynthDef("aLoopingSamplePlayer", { arg outBus = 0, bufnum = 0, rateScale = 1, mul = 1;
	Out.ar(
		outBus,
		PlayBuf.ar(
			1,
			bufnum,
			BufRateScale.kr(bufnum) * rateScale + LFNoise1.kr(2.reciprocal, 0.05),
			loop: 1	// 停止することなくサウンド・ファイルを繰り返し再生する
		)
		*
		mul
	)
}).add;

// オーディオ・ソースに振幅変調を適用する
SynthDef("ampMod", { arg inBus = 0, outBus = 0, modFreq = 1;
	Out.ar(
		outBus,
		[In.ar(inBus, 1) * SinOsc.kr(modFreq), In.ar(inBus, 1) * SinOsc.kr(modFreq - 0.02)]
	)
}).add;

// オーディオ・ソースにローパス・フィルターを適用する
SynthDef("aLowPassFilter", { arg inBus = 0, outBus = 0, freq = 300, freqDev = 50, boost = 1;
	Out.ar(
		outBus,
		RLPF.ar(
			In.ar(inBus, 2),
			Lag.kr(LFNoise0.kr(1, freqDev, freq), 1),
			0.1
		)
		*
		boost
	)
}).add;
)
