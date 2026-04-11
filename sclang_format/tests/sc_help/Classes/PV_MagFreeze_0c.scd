// Source: Classes/PV_MagFreeze.schelp block 0 (part 3/5)
(
SynthDef("help-magFreeze", { arg out=0;
	var in, chain;
	in = SinOsc.ar(LFNoise1.kr(5.2,250,400));
	chain = FFT(LocalBuf(2048), in);
	// moves in and out of freeze
	chain = PV_MagFreeze(chain, SinOsc.kr(0.2) );
	Out.ar(out, 0.1 * IFFT(chain).dup);
}).play(s);

)
