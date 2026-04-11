// Source: Guides/Tour_of_UGens.schelp block 71 (part 6/9)
(
// brick wall filter.
{
	var in, chain;
	in = PlayBuf.ar(1,c, BufRateScale.kr(c), loop:1);
	chain = FFT(b, in);
	chain = PV_BrickWall(chain, MouseX.kr(-1,1));
	0.5 * IFFT(chain);
}.scope(1);
)
