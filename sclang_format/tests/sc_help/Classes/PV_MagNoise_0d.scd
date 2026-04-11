// Source: Classes/PV_MagNoise.schelp block 0 (part 4/5)
(
SynthDef("help-magNoise2", {  arg out=0, soundBufnum=2;
	var in, chain;
	in = PlayBuf.ar(1, soundBufnum, BufRateScale.kr(soundBufnum), loop: 1);
	chain = FFT(LocalBuf(2048), in);
	chain = PV_MagNoise(chain);
	Out.ar(out, 0.2 * IFFT(chain).dup);
}).play(s,[\soundBufnum, b]);
)
