// Source: Guides/Debugging-tips.schelp block 13 (part 1/5)
SynthDef(\resonz, { |out, freq = 440|
	var	sig, ffreq;
	sig = Saw.ar([freq, freq+1], 0.2);
	ffreq = LFNoise1.kr(2, 1, 0.5);
	Out.ar(out, Resonz.ar(sig, (800, 1000..1800) * ffreq, 0.1))
}).send(s);
