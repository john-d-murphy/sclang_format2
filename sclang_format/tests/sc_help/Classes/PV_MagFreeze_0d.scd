// Source: Classes/PV_MagFreeze.schelp block 0 (part 4/5)
(
//trig with MouseY
SynthDef("help-magFreeze2", { arg out=0, soundBufnum=2;
	var in, chain;
	in = PlayBuf.ar(1, soundBufnum, BufRateScale.kr(soundBufnum), loop: 1);
	chain = FFT(LocalBuf(2048), in);
	chain = PV_MagFreeze(chain, MouseY.kr > 0.5 );
	Out.ar(out, 0.1 * IFFT(chain).dup);
}).play(s,[\soundBufnum, b]);
)
