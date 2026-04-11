// Source: Guides/FFT-Overview.schelp block 8
(
x = { var inA, chainA, chainB;
	inA = LFClipNoise.ar(100);
	chainA = FFT(LocalBuf(2048, 1), inA);
	chainB = PV_PhaseShift(chainA, pi);
	// half-circle phase shift should result in an inverse signal
	// in practice, ultra-low frequencies sneak through
	// but you won't hear very much here
	IFFT(chainA) + IFFT(chainB);
}.play;
)
