// Source: Classes/PV_ChainUGen.schelp block 9 (part 3/3)
(
{
	var in, chain, v;
	in = PlayBuf.ar(1, c, BufRateScale.kr(c), loop: 1);
	chain = FFT(LocalBuf(1024), in);

	v = LFPar.kr(0.5).range(0.1, 1);

	chain = chain.pvcollect(1024, {|mag, phase, index|

//////// Try uncommenting each of these lines in turn and re-running the synth:
		//mag;
		//[mag, phase];
		//[mag, phase] / 3;
		//[mag, phase].sqrt;
		//[mag, 3.14.rand];
		//[mag, LFNoise0.kr.range(0, 3.14)];
		//[mag * Dseq([1, 0, 0, 1, 1, 0, 1, 0].dupEach(8), 999999999999)]; // Can even use Demand ugens! One val demanded each frame
		//[mag.sqrt, 3.14.rand];
		//if(index % 7 == 0, mag, 0); // Comb filter
		//if(LFNoise0.kr(10) > 0.5, mag, 0);
		//mag + DelayN.kr(mag, 1, v); // Spectral delay

		if((index - LFPar.kr(0.1).range(2, 1024/20)).abs < 10, mag, 0); // Swept bandpass

	}, frombin: 0, tobin: 250, zeroothers: 0);

	0.5 * IFFT(chain).dup
}.play
)
