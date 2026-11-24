// Source: Classes/PV_Copy.schelp block 0 (part 2/15)
(
{
	var in, in2, chain, chainB, chainC;
	in = PlayBuf.ar(1, d, BufRateScale.kr(d), loop: 1) * 2;
	in2 = WhiteNoise.ar;
	chain = FFT(LocalBuf(2048), in);
	chainB = FFT(LocalBuf(2048), in2);
	chainC = PV_Copy(chain, LocalBuf(2048));
	chainB = PV_MagMul(chainB, chainC);
	XFade2.ar(IFFT(chain), IFFT(chainB) * 0.1, SinOsc.kr(0.2, 1.5pi));
}.play

)
