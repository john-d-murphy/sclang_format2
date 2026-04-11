// Source: Classes/PV_MagShift.schelp block 0 (part 6/6)
(
SynthDef("help-magShift2", {  arg out=0, soundBufnum=2;
	var in, chain;
	in = PlayBuf.ar(1, soundBufnum, BufRateScale.kr(soundBufnum), loop: 1);
	chain = FFT(LocalBuf(2048), in);
	chain = PV_MagShift(chain, 1, MouseX.kr(-128, 128) );
	Out.ar(out, 0.1 * IFFT(chain).dup);
}).play(s, [\soundBufnum, b]);
)
