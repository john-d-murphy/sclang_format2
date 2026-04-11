// Source: Classes/FFT.schelp block 1 (part 3/9)
(
{
	var in, chain;
	in = SinOsc.ar(SinOsc.kr(SinOsc.kr(0.08,0,6,6.2).squared, 0, 100, 800));
	chain = FFT(LocalBuf(2048), in);
	IFFT(chain)
}.play;
)
