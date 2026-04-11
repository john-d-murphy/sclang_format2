// Source: Classes/PV_Diffuser.schelp block 0 (part 1/2)
(
// trig with MouseY crossing center of screen
{
	var in, chain;
	in = Mix.ar(SinOsc.ar(200 * (1..10), 0, Array.fill(10, { rrand(0.1, 0.2) }) ));
	chain = FFT(LocalBuf(2048), in);
	chain = PV_Diffuser(chain, MouseY.kr > 0.5 );
	0.5 * IFFT(chain).dup;
}.play
);
