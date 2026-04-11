// Source: Guides/FFT-Overview.schelp block 4
(
{
  var in, chain;
	in = Ringz.ar(Impulse.ar([2, 3]), [700, 800], 0.1) * 5; // stereo input
	chain = FFT({ LocalBuf(2048) } ! 2, in); // array of two local buffers
	chain = PV_RandComb(chain, 0.95, Impulse.kr(0.4));
	IFFT(chain) // returns a stereo out
}.play;
)
