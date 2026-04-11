// Source: Classes/FFT.schelp block 1 (part 1/9)
(
{
	var in, chain;
	in = WhiteNoise.ar(0.1);
	chain = FFT(LocalBuf(2048), in);
	IFFT(chain) // inverse FFT
}.play;
)
