// Source: Classes/PV_RandComb.schelp block 0 (part 3/4)
(
SynthDef("help-randcomb", { | out=0 |
	var sig, chain;
	sig = WhiteNoise.ar(0.8);
	chain = FFT(LocalBuf(2048), sig);
	chain = PV_RandComb(chain, 0.95, Impulse.kr(0.4));
	Out.ar(out, IFFT(chain).dup);
}).play(s);
)
