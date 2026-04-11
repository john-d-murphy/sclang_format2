// Source: Classes/PV_MagMul.schelp block 0 (part 4/5)
(
SynthDef("help-magMul2", { arg out=0, soundBufnum=2;
	var inA, chainA, inB, chainB, chain;
	inA = LFSaw.ar([100, 150], 0, 0.2);
	inB = PlayBuf.ar(1, soundBufnum, BufRateScale.kr(soundBufnum), loop: 1);
	chainA = FFT(LocalBuf(2048), inA);
	chainB = FFT(LocalBuf(2048), inB);
	chain = PV_MagMul(chainA, chainB);
	Out.ar(out,  0.03 * IFFT(chain));
}).play(s, [\soundBufnum, b.bufnum]);
)
