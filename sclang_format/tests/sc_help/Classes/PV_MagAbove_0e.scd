// Source: Classes/PV_MagAbove.schelp block 0 (part 5/5)
(
SynthDef("help-magAbove3", { arg out=0, soundBufnum=2;
	var in, chain;
	in = PlayBuf.ar(1, soundBufnum, BufRateScale.kr(soundBufnum), loop: 1);
	chain = FFT(LocalBuf(2048), in);
	chain = PV_MagAbove(chain, MouseX.kr(0, 310));
	Out.ar(out, 0.1 * IFFT(chain).dup);
}).play(s, [\soundBufnum, b]);
)
