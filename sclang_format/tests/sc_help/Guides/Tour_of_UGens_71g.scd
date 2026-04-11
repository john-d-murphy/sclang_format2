// Source: Guides/Tour_of_UGens.schelp block 71 (part 7/9)
(
// pass random frequencies. Mouse controls how many to pass.
// trigger changes the frequencies periodically
{
	var in, chain;
	in = PlayBuf.ar(1,c, BufRateScale.kr(c), loop:1);
	chain = FFT(b, in);
	chain = PV_RandComb(chain, MouseX.kr(0,1), Impulse.kr(0.4));
	0.5 * IFFT(chain);
}.scope(1);
)
