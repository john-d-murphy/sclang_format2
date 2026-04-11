// Source: Guides/Tour_of_UGens.schelp block 71 (part 3/9)
(
// do nothing
{
	var in, chain;
	in = PlayBuf.ar(1,c, BufRateScale.kr(c), loop:1);
	chain = FFT(b, in);
	0.5 * IFFT(chain);
}.scope(1);
)
