// Source: Guides/FFT-Overview.schelp block 7
(
{
	var in, in2, chainA, chainB, chainC;
	var mod = LFNoise2.kr(2);
	in = Blip.ar(mod.exprange(4000, 2), 231);
	in2 = SinOsc.ar(mod.exprange(200, 4000));
	chainA = FFT(LocalBuf(2048), in);
	chainB = FFT(LocalBuf(2048), in2);
	chainC = PV_Copy(chainA, LocalBuf(2048));
	chainB = PV_MagMul(chainB, chainC);
	XFade2.ar(
		IFFT(chainA) * 0.4,
		IFFT(chainB) * 0.1,
		MouseX.kr(-1, 1)
	);
}.play
)
