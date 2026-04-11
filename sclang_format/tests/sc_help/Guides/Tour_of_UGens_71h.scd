// Source: Guides/Tour_of_UGens.schelp block 71 (part 8/9)
(
// rectangular comb filter
{
	var in, chain;
	in = PlayBuf.ar(1,c, BufRateScale.kr(c), loop:1);
	chain = FFT(b, in);
	chain = PV_RectComb(chain, 8, MouseY.kr(0,1), MouseX.kr(0,1));
	0.5 * IFFT(chain);
}.scope(1);
)
