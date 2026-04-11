// Source: Classes/FFT.schelp block 1 (part 9/9)
(
{
	var in, chain;
	in = SinOsc.ar(LFNoise1.kr([5.2, 3.3],250,400));
	chain = FFT({ LocalBuf(2048) } ! 2, in); // we need two buffers for stereo input.
	// moves in and out of freeze
	chain = PV_MagFreeze(chain, SinOsc.kr([0.2, 0.3]) );
	0.5 * IFFT(chain);
}.play;
)
