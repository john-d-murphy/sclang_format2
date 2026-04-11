// Source: Tutorials/Mark_Polishook_tutorial/16_Playbuf.schelp block 0 (part 1/3)
(
// read a soundfile from disk
b = Buffer.read(s, Platform.resourceDir +/+ "sounds/a11wlk01.wav");

// a samplePlayer in mono ... one channel only
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
