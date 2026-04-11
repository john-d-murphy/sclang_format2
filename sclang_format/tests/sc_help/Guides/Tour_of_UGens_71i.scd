// Source: Guides/Tour_of_UGens.schelp block 71 (part 9/9)
(
// freeze magnitudes
{
	var in, chain;
	in = PlayBuf.ar(1,c, BufRateScale.kr(c), loop:1);
	chain = FFT(b, in);
	chain = PV_MagFreeze(chain, LFPulse.kr(1, 0.75));
	0.5 * IFFT(chain);
}.scope(1);
)
