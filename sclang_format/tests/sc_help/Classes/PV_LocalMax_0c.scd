// Source: Classes/PV_LocalMax.schelp block 0 (part 3/4)
(
SynthDef("help-localMax", { arg out=0;
	var in, chain;
	in = Mix.arFill(3, { LFSaw.ar(exprand(100, 500), 0, 0.1); });
	chain = FFT(LocalBuf(2048), in);
	chain = PV_LocalMax(chain, MouseX.kr(0, 50));
	Out.ar(out, 0.5 * IFFT(chain).dup);
}).play(s);
)
