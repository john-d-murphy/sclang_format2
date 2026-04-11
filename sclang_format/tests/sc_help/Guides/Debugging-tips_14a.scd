// Source: Guides/Debugging-tips.schelp block 14 (part 1/4)
SynthDef(\resonz, { |out, freq = 440|
	var	sig, ffreq;
	sig = Mix.ar(Saw.ar([freq, freq+1], 0.2));
	ffreq = LFNoise1.kr(2, 0.5, 1);
	Out.ar(out, Mix.ar(Resonz.ar(sig, (800, 1000..1800) * ffreq, 0.1)))
}).send(s);
