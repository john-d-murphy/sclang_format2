// Source: Guides/FFT-Overview.schelp block 3
(
{
  var in, chain;
	in = WhiteNoise.ar(0.8);
	chain = FFT(LocalBuf(2048), in); // encode to frequency domain
	chain = PV_RandComb(chain, 0.95, Impulse.kr(0.4)); // process
	IFFT(chain) // decode to time domain
}.play;
)
