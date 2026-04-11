// Source: Classes/PV_MagBelow.schelp block 0 (part 4/5)
(
SynthDef("help-magBelow2", { arg out=0, bufnum=0;
	var in, chain;
	in = WhiteNoise.ar(0.2);
	chain = FFT(bufnum, in);
	chain = PV_MagBelow(chain, MouseX.kr(0, 7));
	Out.ar(out, 0.5 * IFFT(chain).dup);
}).play(s,[\out, 0, \bufnum, b.bufnum]);
)
