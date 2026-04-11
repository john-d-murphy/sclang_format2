// Source: Classes/PV_BinShift.schelp block 0 (part 5/6)
(
SynthDef("help-binShift", { arg out=0, bufnum=0;
	var in, chain;
	in = LFSaw.ar(200, 0, 0.2);
	chain = FFT(LocalBuf(2048), in);
	chain = PV_BinShift(chain, 1, MouseX.kr(-128, 128) );
	Out.ar(out, 0.5 * IFFT(chain).dup);
}).play;
)
