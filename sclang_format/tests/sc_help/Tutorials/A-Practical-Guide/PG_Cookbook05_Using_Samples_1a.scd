// Source: Tutorials/A-Practical-Guide/PG_Cookbook05_Using_Samples.schelp block 1 (part 1/4)
(
b = Buffer.read(s, ExampleFiles.child);

// one loop segment
SynthDef(\oneLoop, { |out, bufnum, start, time, amp, rate = 1|
	var sig = PlayBuf.ar(1, bufnum,
		rate: rate * BufRateScale.kr(bufnum),
		startPos: start, loop: 0
	),
	env = EnvGen.kr(Env.linen(0.01, time, 0.05, level: amp),
		doneAction: Done.freeSelf);
	Out.ar(out, (sig * env).dup);
}).add;

SynthDef(\bell, { |out, accent = 0, amp = 0.1, decayScale = 1|
	var exc = PinkNoise.ar(amp)
	* Decay2.kr(Impulse.kr(0), 0.01, 0.05),
	sig = Klank.ar(`[
		{ ExpRand(400, 1600) } ! 4,
		1 ! 4,
		{ ExpRand(0.1, 0.4) } ! 4
	], exc, freqscale: accent + 1, decayscale: decayScale);
	DetectSilence.ar(sig, doneAction: Done.freeSelf);
	Out.ar(out, sig.dup)
}).add;
)
