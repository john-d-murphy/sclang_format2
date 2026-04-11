// Source: Classes/FFT.schelp block 1 (part 7/9)
(
{
	var in, chain;
	in = WhiteNoise.ar(0.2);
	chain = FFT(LocalBuf(2048), in);
	chain = PV_RectComb(chain, 8, LFTri.kr(0.097,0,0.4,0.5),
		LFTri.kr(0.24,0,-0.5,0.5));
	IFFT(chain)
}.play;
)
