// Source: Classes/PV_MagAbove.schelp block 0 (part 3/5)
(
SynthDef("help-magAbove", { arg out=0;
	var in, chain;
	in = SinOsc.ar(SinOsc.kr(SinOsc.kr(0.08, 0, 6, 6.2).squared, 0, 100, 800));
	//in = WhiteNoise.ar(0.2);
	chain = FFT(LocalBuf(2048), in);
	chain = PV_MagAbove(chain, 310);
	Out.ar(out, 0.1 * IFFT(chain).dup);
}).play(s);
)
