// Source: Classes/FreqShift.schelp block 1 (part 5/6)
(
r.stop; // stop old routine
Buffer.read(s, Platform.resourceDir +/+ "sounds/a11wlk01.wav", bufnum:99);

SynthDef(\frqShift1, { |out, freq, bufnum|
	var e1,snd,left,right;
	e1 = Env.new([0,1,0], [3,1], -4);
	snd = PlayBuf.ar(1, bufnum, BufRateScale.kr(bufnum) * 0.01, loop:1);
	// subtle shift of the output
	left = FreqShift.ar(snd, freq * 2, 0, EnvGen.ar(e1, 1, doneAction: Done.freeSelf));
	right = FreqShift.ar(snd, freq * 3, 0, EnvGen.ar(e1, 1, doneAction: Done.freeSelf));
	Out.ar(out, [left, right] * 3);
}).add;
)
