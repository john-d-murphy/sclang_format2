// Source: Classes/LocalBuf.schelp block 2 (part 1/11)
(
{
var in, chain;
	in = WhiteNoise.ar(0.1.dup);
	chain = FFT({LocalBuf(2048, 1)}.dup, in);
	chain = PV_BrickWall(chain, SinOsc.kr([0.1, 0.11]));
	IFFT(chain) // inverse FFT
}.play;
)
