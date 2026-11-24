// Source: Classes/PV_Copy.schelp block 0 (part 4/15)
(
{
	var in, chain, chainB, pan;
	in = PlayBuf.ar(1, d, BufRateScale.kr(d), loop: 1);
	chain = FFT(LocalBuf(2048), in);
	chainB = PV_Copy(chain, LocalBuf(2048));
	pan = MouseX.kr(0.001, 1.001, 'exponential') - 0.001;
	chain = PV_BrickWall(chain, pan);
	chainB = PV_BrickWall(chainB, -1 + pan);
	IFFT([chain, chainB])
}.play
)
