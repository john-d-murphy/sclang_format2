// Source: Classes/PV_RectComb.schelp block 0 (part 2/2)
(
{
	var sig, chain;
	sig = WhiteNoise.ar(0.2);
	chain = FFT(LocalBuf(2048), sig);
	chain = PV_RectComb(chain,  MouseX.kr(0, 32), MouseY.kr, 0.2);
	IFFT(chain).dup
}.play;
)
