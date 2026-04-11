// Source: Classes/PV_BinWipe.schelp block 0 (part 3/4)
(
SynthDef("help-binWipe", { arg out=0;
	var inA, chainA, inB, chainB, chain;
	inA = WhiteNoise.ar(0.2);
	inB = LFSaw.ar(100, 0, 0.2);
	chainA = FFT(LocalBuf(2048), inA);
	chainB = FFT(LocalBuf(2048), inB);
	chain = PV_BinWipe(chainA, chainB, MouseX.kr(-1, 1));
	Out.ar(out, 0.1 * IFFT(chain).dup);
}).play(s);
)
