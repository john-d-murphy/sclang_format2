// Source: Classes/PV_MagDiv.schelp block 0 (part 2/5)
(
SynthDef("help-magMul", { arg out=0;
	var inA, chainA, inB, chainB, chain;
	inA = WhiteNoise.ar(0.2);
	inB = LFSaw.ar(100, 0, 0.2);
	chainA = FFT(LocalBuf(2048), inA);
	chainB = FFT(LocalBuf(2048), inB);
	chain = PV_MagDiv(chainA, chainB);
	Out.ar(out, 0.5 * IFFT(chain).dup);
}).play;
)
