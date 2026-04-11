// Source: Classes/PV_Diffuser.schelp block 0 (part 2/2)
(
b = Buffer.read(s, Platform.resourceDir +/+ "sounds/a11wlk01.wav");

// trig with MouseY crossing center of screen
{
	var in, chain;
	in = PlayBuf.ar(1, b, BufRateScale.kr(b), loop: 1);
	chain = FFT(LocalBuf(2048), in);
	chain = PV_Diffuser(chain, MouseY.kr > 0.5 );
	0.5 * IFFT(chain).dup;
}.play
);
