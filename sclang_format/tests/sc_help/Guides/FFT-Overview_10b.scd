// Source: Guides/FFT-Overview.schelp block 10 (part 2/4)
(
x = {
	var in, numFrames=2048, chain, v;
	in = PlayBuf.ar(1, c, loop: 1);
	chain = FFT(LocalBuf(numFrames), in);

	chain = chain.pvcalc(numFrames, {|mags, phases|
		/* Play with the mags and phases, then return them */
		[mags, phases].flop.clump(2).flop.flatten
	}, tobin: 250);

	0.5 * IFFT(chain).dup
}.play;
)
