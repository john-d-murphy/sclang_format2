// Source: Classes/PV_BrickWall.schelp block 0 (part 2/2)
(
{
	var in, chain;
	in = WhiteNoise.ar(0.2);
	chain = FFT(LocalBuf(2048), in);
	chain = PV_BrickWall(chain, SinOsc.kr(0.1));
	IFFT(chain);
}.play
)
