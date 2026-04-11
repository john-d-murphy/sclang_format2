// Source: Classes/PV_MagShift.schelp block 0 (part 3/6)
(
SynthDef("help-magStretch", { arg out=0, bufnum=0;
	var in, chain;
	in = LFSaw.ar(200, 0, 0.2);
	chain = FFT(LocalBuf(2048), in);
	chain = PV_MagShift(chain, MouseX.kr(0.25, 4, \exponential) );
	Out.ar(out, 0.1 * IFFT(chain).dup);
}).play(s);
)
