// Source: Classes/PV_MagClip.schelp block 0 (part 5/5)
(
SynthDef("help-magClip2", { |out = 0, soundBufnum = 2|
	var in, chain;
	in = PlayBuf.ar(1, soundBufnum, BufRateScale.kr(soundBufnum), loop: 1);
	chain = FFT(LocalBuf(2048), in);
	chain = PV_MagClip(chain, MouseX.kr(0, 50));
	Out.ar(out, 0.5 * IFFT(chain).dup);
}).play(s, [\soundBufnum, b]);
)
