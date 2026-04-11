// Source: Tutorials/Mark_Polishook_tutorial/Japanese_version/12.schelp block 0 (part 1/3)
(
// ディスクからサウンド・ファイルを読み込む
b = Buffer.read(s, Platform.resourceDir +/+ "sounds/a11wlk01.wav");

// モノのサンプル・プレーヤー ... １チャンネルのみ
SynthDef("aMonoSamplePlayer", { arg bus = 0, bufnum = 0, rateScale = 1;
	Out.ar(
		bus,
		PlayBuf.ar(
			1,
			bufnum,
			BufRateScale.kr(bufnum) * rateScale
		)
		*
		EnvGen.kr(Env.sine(BufDur.kr(bufnum)))
	)
}).add;
)
