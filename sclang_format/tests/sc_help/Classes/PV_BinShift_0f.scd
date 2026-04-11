// Source: Classes/PV_BinShift.schelp block 0 (part 6/6)
(
SynthDef("help-binShift2", {  arg out=0, soundBufnum=2;
	var in, chain;
	in = PlayBuf.ar(1, soundBufnum, BufRateScale.kr(soundBufnum), loop: 1);
	chain = FFT(LocalBuf(2048), in);
	chain = PV_BinShift(chain, 1, MouseX.kr(-128, 128) );
	Out.ar(out, 0.5 * IFFT(chain).dup);
}).play(s,[\out, 0, \soundBufnum, c.bufnum]);
)
