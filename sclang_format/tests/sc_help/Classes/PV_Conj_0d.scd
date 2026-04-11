// Source: Classes/PV_Conj.schelp block 0 (part 4/4)
(
SynthDef(\help_pvconj2, {  arg out=0, bufnum=0, soundBufnum=2;
	var in, chainA, chainB;
	in = PlayBuf.ar(1, soundBufnum, BufRateScale.kr(soundBufnum), loop: 1);
	chainA = FFT(bufnum, in);
	chainB = PV_Copy(chainA, d);
	chainB = PV_Conj(chainB);
	// Now we have the original and conjugate, what happens if we add them?
	Out.ar(out, 0.3 * (IFFT(PV_Add(chainA, chainB)).dup));
}).play(s,[\out, 0, \bufnum, b, \soundBufnum, c]);
)
