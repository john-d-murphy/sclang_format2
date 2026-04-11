// Source: Classes/PV_MagSmear.schelp block 0 (part 3/4)
(
SynthDef("help-magSmear", { arg out=0, bufnum=0;
	var in, chain;
	in = LFSaw.ar(500, 0, Decay2.ar(Impulse.ar(2,0,0.2), 0.01, 2));
	chain = FFT(bufnum, in);
	chain = PV_MagSmear(chain, MouseX.kr(0, 100));
	Out.ar(out, 0.5 * IFFT(chain).dup);
}).play(s,[\out, 0, \bufnum, b.bufnum]);
)
