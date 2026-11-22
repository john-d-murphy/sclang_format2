// Source: Classes/PV_Copy.schelp block 0 (part 12/15)
(
x = { var in, chain, chainB, chainC;
	in = WhiteNoise.ar;
	chain = FFT(LocalBuf(~fftSize), in);
	chain = ~copyToBuffer.(chain, 'initial'); // initial spectrum
	chain = PV_RectComb(chain, 20, 0, 0.2);
	chain = ~copyToBuffer.(chain, 'After RectComb'); // after comb
	2.do { chain = PV_MagSquared(chain) };
	chain = ~copyToBuffer.(chain, 'After MagSquared'); // after magsquared
	0.00001 * Pan2.ar(IFFT(chain)); // silently play back
}.play
)
