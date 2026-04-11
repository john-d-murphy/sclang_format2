// Source: Classes/FFT.schelp block 1 (part 6/9)
(
{
	var in, chain;
	in = WhiteNoise.ar(0.8);
	chain = FFT(LocalBuf(2048), in);
	chain = PV_RandComb(chain, 0.95, Impulse.kr(0.4));
	IFFT(chain)
}.play;
)
