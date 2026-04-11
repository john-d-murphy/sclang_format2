// Source: Classes/PV_CopyPhase.schelp block 0 (part 3/4)
(
SynthDef("help-copyPhase", { arg out=0;
	var inA, chainA, inB, chainB, chain;
	inA = SinOsc.ar(SinOsc.kr(SinOsc.kr(0.08, 0, 6, 6.2).squared, 0, 100, 800));
	inB = WhiteNoise.ar(0.2);
	chainA = FFT(LocalBuf(2048), inA);
	chainB = FFT(LocalBuf(2048), inB);
	chain = PV_CopyPhase(chainA, chainB);
	Out.ar(out, 0.1 * IFFT(chain).dup);
}).play(s);
)
