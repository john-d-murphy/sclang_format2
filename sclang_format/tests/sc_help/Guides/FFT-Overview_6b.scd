// Source: Guides/FFT-Overview.schelp block 6 (part 2/3)
(
{
  var inA, chainA, inB, chainB, chain;
	inA = LFSaw.ar(100, 0, 0.2);
	inB = PlayBuf.ar(1, d, BufRateScale.kr(d), loop: 1);
	chainA = FFT(LocalBuf(2048), inA);
	chainB = FFT(LocalBuf(2048), inB);
	chain = PV_MagMul(chainA, chainB); // writes into bufferA
	IFFT(chain) * 0.1
}.play;
)
