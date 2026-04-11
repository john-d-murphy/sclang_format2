// Source: Guides/FFT-Overview.schelp block 5 (part 1/2)
(
{
  var inA, chainA, inB, chainB, chain;
	inA = LFSaw.ar(MouseY.kr(100, 1000, 1), 0, 0.2);
	inB = Ringz.ar(Impulse.ar(MouseX.kr(1, 100, 1)), 700, 0.5);
	// make two parallel chains
	chainA = FFT(LocalBuf(2048), inA);
	chainB = FFT(LocalBuf(2048), inB);
	chain = PV_MagMul(chainA, chainB); // writes into bufferA
	IFFT(chain) * 0.1
}.play;
)
