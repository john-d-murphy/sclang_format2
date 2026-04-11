// Source: Classes/PV_Mul.schelp block 1 (part 3/3)
(
SynthDef("help-mul2", { arg out=0;
	var inA, chainA, inB, chainB, chain ;
	inA = SinOsc.ar(500, 0, 0.5) * Line.kr;
	inB = LFNoise1.ar(20);
	chainA = FFT(LocalBuf(2048), inA);
	chainB = FFT(LocalBuf(2048), inB);
	chain = PV_Mul(chainA, chainB);
	Out.ar(out,  0.1 * IFFT(chain).dup);
}).play(s);
s.scope;
)
