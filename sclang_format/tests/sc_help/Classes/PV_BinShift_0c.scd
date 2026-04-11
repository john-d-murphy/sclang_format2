// Source: Classes/PV_BinShift.schelp block 0 (part 3/6)
(
SynthDef("help-binStretch", { arg out=0;
	var in, chain;
	in = LFSaw.ar(200, 0, 0.2);
	chain = FFT(LocalBuf(2048), in);
	chain = PV_BinShift(chain, MouseX.kr(0.25, 4, \exponential) );
	Out.ar(out, 0.5 * IFFT(chain).dup);
}).play;
)
