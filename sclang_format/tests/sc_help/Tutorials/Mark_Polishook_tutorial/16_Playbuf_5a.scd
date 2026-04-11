// Source: Tutorials/Mark_Polishook_tutorial/16_Playbuf.schelp block 5 (part 1/4)
(
// read a soundfile
b = Buffer.read(s, Platform.resourceDir +/+ "sounds/a11wlk01.wav");

// define a sample player that will loop over a soundfile
SynthDef("aLoopingSamplePlayer", { arg outBus = 0, bufnum = 0, rateScale = 1, mul = 1;
	Out.ar(
		outBus,
		PlayBuf.ar(
			1,
			bufnum,
			BufRateScale.kr(bufnum) * rateScale + LFNoise1.kr(2.reciprocal, 0.05),
			loop: 1	// play the soundfile over and over without stopping
		)
		*
		mul
	)
}).add;

// apply amplitude modulation to an audio source
SynthDef("ampMod", { arg inBus = 0, outBus = 0, modFreq = 1;
	Out.ar(
		outBus,
		[	// In.ar ugen reads from an audio bus
			In.ar(inBus, 1) * SinOsc.kr(modFreq),
			In.ar(inBus, 1) * SinOsc.kr(modFreq - 0.02)
		]
	)
}).add;

// apply a low pass filter to an audio source
SynthDef("aLowPassFilter", { arg inBus = 0, outBus = 0, freq = 300, freqDev = 50, boost = 1;
	Out.ar(
		outBus,
		RLPF.ar(
			In.ar(inBus, 2),
			Lag.kr(LFNoise0.kr(1, freqDev, freq), 1),
			0.2
		)
		*
		boost
		*
		LFPulse.kr(1, [0.25, 0.75], [0.5, 0.45])
		+
		In.ar(inBus, 2)
	)
}).add;
)
