// Source: Classes/PV_RandComb.schelp block 0 (part 4/4)
(
//trig with MouseY
SynthDef("help-randcomb2", { | out=0, soundBufnum=2 |
	var sig, chain;
	sig = PlayBuf.ar(1, soundBufnum, BufRateScale.kr(soundBufnum), loop: 1);
	chain = FFT(LocalBuf(2048), sig);
	chain = PV_RandComb(chain, MouseY.kr, Impulse.kr(0.4));
	Out.ar(out, IFFT(chain).dup);
}).play(s,[\soundBufnum, c.bufnum]);
)
