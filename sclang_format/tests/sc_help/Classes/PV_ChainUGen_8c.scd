// Source: Classes/PV_ChainUGen.schelp block 8 (part 3/3)
(
x = {
	var fftsize = 1024;
	var in, chain, in2, chain2, out;
	in = PlayBuf.ar(1, c, BufRateScale.kr(c), loop: 1);
	chain = FFT(LocalBuf(fftsize), in);

	// JMcC babbling brook
	in2 = ({
		RHPF.ar(OnePole.ar(BrownNoise.ar, 0.99), LPF.ar(BrownNoise.ar, 14)
			* 400 + 500, 0.03, 0.003) }!2)
			+ ({ RHPF.ar(OnePole.ar(BrownNoise.ar, 0.99), LPF.ar(BrownNoise.ar, 20)
			* 800 + 1000, 0.03, 0.005) }!2
		) * 4;
	chain2 = FFT(LocalBuf(fftsize), in2);

	chain = chain.pvcalc2(chain2, fftsize, { |mags, phases, mags2, phases2|
		[
			mags * mags2 / 10,
			phases2 + phases
		]
	}, frombin: 0, tobin: 125, zeroothers: 0);

	out = IFFT(chain);
	0.5 * out.dup
}.play
)
