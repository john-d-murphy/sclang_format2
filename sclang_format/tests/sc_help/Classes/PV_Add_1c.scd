// Source: Classes/PV_Add.schelp block 1 (part 3/4)
(
SynthDef("help-add", { arg out=0, soundBufnum;
	var inA, chainA, inB, chainB, chain ;
	inA = PlayBuf.ar(1, soundBufnum, BufRateScale.kr(soundBufnum), loop: 1);
	inB =  PlayBuf.ar(1, soundBufnum, BufRateScale.kr(soundBufnum) * 0.5, loop: 1);
	chainA = FFT(LocalBuf(2048), inA);
	chainB = FFT(LocalBuf(2048), inB);
	chain = PV_Add(chainA, chainB);
	Out.ar(out,  0.1 * IFFT(chain).dup);
}).play(s, [\soundBufnum, b.bufnum]);
)
