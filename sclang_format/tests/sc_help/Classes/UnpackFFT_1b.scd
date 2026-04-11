// Source: Classes/UnpackFFT.schelp block 1 (part 2/2)
(
x = {
	var sig, chain, magsphases, b;
	b = LocalBuf(1, 1024);
	sig = SinOsc.ar(LFDNoise3.kr(LFNoise0.kr(1) * 40 + 60) * 700 + 800);
	chain = FFT(b, sig);
	magsphases = UnpackFFT(chain, b.numFrames);
	magsphases = magsphases.collect(_.sqrt);
	chain = PackFFT(chain, b.numFrames, magsphases);
	IFFT(chain) * 0.1
}.play
)
