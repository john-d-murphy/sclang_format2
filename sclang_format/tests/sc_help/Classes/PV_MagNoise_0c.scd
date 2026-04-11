// Source: Classes/PV_MagNoise.schelp block 0 (part 3/5)
(
SynthDef("help-magNoise", { arg out=0;
	var in, chain;
	in = SinOsc.ar(SinOsc.kr(SinOsc.kr(0.08, 0, 6, 6.2).squared, 0, 100, 800));
	chain = FFT(LocalBuf(2048), in);
	chain = PV_MagNoise(chain);
	Out.ar(out, 0.1 * IFFT(chain).dup);
}).play(s);
)
