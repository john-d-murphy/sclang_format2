// Source: Classes/PV_ChainUGen.schelp block 7 (part 3/3)
(
{
	var in, chain, v;
	in = PlayBuf.ar(1, c, BufRateScale.kr(c), loop: 1);
	chain = FFT(LocalBuf(1024), in);

	chain = chain.pvcalc(1024, {|mags, phases|
//////// Try uncommenting each of these lines in turn and re-running the synth:
		[mags * {1.5.rand}.dup(mags.size), phases + {pi.rand}.dup(phases.size)]; // Arbitrary filter, arbitrary phase shift
		//[mags.reverse, phases.reverse]; // Upside-down!
		//[mags.differentiate, phases.differentiate]; // Differentiate along frequency axis
		//[mags[30..] ++ mags[..30], phases[30..] ++ phases[..30]]; // ".rotate" doesn't work directly, but this is equivalent
	}, frombin: 0, tobin: 250, zeroothers: 0);

	0.5 * IFFT(chain).dup
}.play
)
