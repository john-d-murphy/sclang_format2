// Source: Classes/FFT.schelp block 1 (part 8/9)
(
{
	var in, chain;
	in = SinOsc.ar(LFNoise1.kr(5.2,250,400));
	chain = FFT(LocalBuf(2048), in);
	// moves in and out of freeze
	chain = PV_MagFreeze(chain, SinOsc.kr(0.2) );
	0.5 * IFFT(chain);
}.play;
)
