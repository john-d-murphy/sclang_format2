// Source: Classes/LocalBuf.schelp block 2 (part 11/11)
(
{
var in, chain, n = 4;
	in = WhiteNoise.ar(0.1.dup(n));
	chain = FFT({LocalBuf(2048, 1)}.dup(n), in);
	chain = PV_BrickWall(chain, LFNoise2.kr(2.dup(n)));
	Splay.ar(IFFT(chain)) // inverse FFT
}.play;
)
