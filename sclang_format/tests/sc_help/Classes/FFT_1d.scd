// Source: Classes/FFT.schelp block 1 (part 4/9)
(
{
	var in, chain;
	in = SinOsc.ar(SinOsc.kr(SinOsc.kr(0.08,0,6,6.2).squared, 0, 100,800));
	//in = WhiteNoise.ar(0.2);
	chain = FFT(LocalBuf(2048), in);
	chain = PV_MagAbove(chain, 310);
	0.5 * IFFT(chain);
}.play;
)
