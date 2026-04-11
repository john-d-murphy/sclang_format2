// Source: Classes/PV_RandWipe.schelp block 0 (part 2/2)
(
//trig with MouseY
SynthDef("help-randWipe", { arg out=0;
	var inA, chainA, inB, chainB, chain;
	inA = Mix.arFill(6, { LFSaw.ar(exprand(400, 1000), 0, 0.1) });
	inB = Mix.arFill(6, { LFPulse.ar(exprand(80, 400), 0, 0.2, SinOsc.kr(8.0.rand, 0, 0.2).max(0)) });
	chainA = FFT(LocalBuf(2048), inA);
	chainB = FFT(LocalBuf(2048), inB);
	chain = PV_RandWipe(chainA, chainB, MouseX.kr.poll, MouseY.kr.poll > 0.5);
	Out.ar(out, 0.5 * IFFT(chain).dup);
}).play(s);
)
