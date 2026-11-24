// Source: Guides/FFT-Overview.schelp block 9 (part 2/4)
(
x = { var in, chain, chainB, chainC;
	in = WhiteNoise.ar;
	chain = FFT(c, in);
	0.01 * Pan2.ar(IFFT(chain));
}.play(s);
)
