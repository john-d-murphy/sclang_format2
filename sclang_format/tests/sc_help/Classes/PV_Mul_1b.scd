// Source: Classes/PV_Mul.schelp block 1 (part 2/3)
(
SynthDef("help-mul", { arg out=0;
	var inA, chainA, inB, chainB, chain ;
	inA = SinOsc.ar(500, 0, 0.5);
	inB =  SinOsc.ar(Line.kr(100, 400, 5), 0, 0.5);
	chainA = FFT(LocalBuf(2048), inA);
	chainB = FFT(LocalBuf(2048), inB);
	chain = PV_Mul(chainA, chainB);
	Out.ar(out,  0.1 * IFFT(chain).dup);
}).play(s);
s.scope;
)
