// Source: Classes/PV_MagShift.schelp block 0 (part 5/6)
(
SynthDef("help-magShift", { arg out=0;
	var in, chain;
	in = LFSaw.ar(200, 0, 0.2);
	chain = FFT(LocalBuf(2048), in);
	chain = PV_MagShift(chain, 1, MouseX.kr(-128, 128) );
	Out.ar(out, 0.1 * IFFT(chain).dup);
}).play(s);
)
