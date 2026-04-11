// Source: Guides/Tour_of_UGens.schelp block 71 (part 4/9)
(
// pass only magnitudes above a threshold
{
	var in, chain;
	in = PlayBuf.ar(1,c, BufRateScale.kr(c), loop:1);
	chain = FFT(b, in);
	chain = PV_MagAbove(chain, MouseX.kr(0.1,512,1));
	0.5 * IFFT(chain);
}.scope(1);
)
