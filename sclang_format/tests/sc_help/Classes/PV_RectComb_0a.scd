// Source: Classes/PV_RectComb.schelp block 0 (part 1/2)
(
{
	var sig, chain;
	sig = WhiteNoise.ar(0.2);
	chain = FFT(LocalBuf(2048), sig);
	chain = PV_RectComb(chain, 8, LFTri.kr(0.097, 0, 0.4, 0.5),
	LFTri.kr(0.24, 0, -0.5, 0.5));
	IFFT(chain).dup
}.play;
)
