// Source: Classes/PV_Conj.schelp block 0 (part 3/4)
(
SynthDef(\help_pvconj, {  arg out=0, bufnum=0, soundBufnum=2;
	var in, chain;
	in = PlayBuf.ar(1, soundBufnum, BufRateScale.kr(soundBufnum), loop: 1);
	chain = FFT(bufnum, in);
	chain = PV_Conj(chain);
	// Original is left, conj is right
	Out.ar(out, 0.3 * [in, IFFT(chain)]);
}).play(s,[\out, 0, \bufnum, b, \soundBufnum, c]);
)
