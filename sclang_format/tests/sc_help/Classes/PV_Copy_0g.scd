// Source: Classes/PV_Copy.schelp block 0 (part 7/15)
(
x = {
	var inA, chainA, chainB;
    inA = LFClipNoise.ar(100);
    chainA = FFT(b, inA);
    chainB = PV_Copy(chainA, c);
    IFFT(chainA) - IFFT(chainB); // proof of concept: cancels to zero
}.play;
)
