// Source: Classes/PV_MagAbove.schelp block 0 (part 4/5)
(
SynthDef("help-magAbove2", { arg out=0;
	var in, chain;
	in = WhiteNoise.ar(0.2);
	chain = FFT(LocalBuf(2048), in);
	chain = PV_MagAbove(chain, MouseX.kr(0, 10));
	Out.ar(out, 0.1 * IFFT(chain).dup);
}).play(s);
)
