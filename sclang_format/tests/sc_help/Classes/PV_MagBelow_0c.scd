// Source: Classes/PV_MagBelow.schelp block 0 (part 3/5)
(
SynthDef("help-magBelow", { arg out=0, bufnum=0;
	var in, chain;
	in = SinOsc.ar(SinOsc.kr(SinOsc.kr(0.08, 0, 6, 6.2).squared, 0, 100, 800));
	chain = FFT(bufnum, in);
	chain = PV_MagBelow(chain, 10);
	Out.ar(out, 0.5 * IFFT(chain).dup);
}).play(s,[\out, 0, \bufnum, b.bufnum]);
)
