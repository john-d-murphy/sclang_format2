// Source: Classes/LocalBuf.schelp block 2 (part 2/11)
(
SynthDef(\fftgrain, { |out, sustain = 1, rate = 0.2|
	var in, chain;
	in = WhiteNoise.ar(0.1).dup;
	chain = FFT({LocalBuf(128, 1)}.dup, in);
	chain = PV_BrickWall(chain,
		SinOsc.kr(rate * XLine.kr(1, 15 * [1, 1.6], sustain), Rand(0, pi))
	);
	Out.ar(out, IFFT(chain) * XLine.kr(1, 0.001, sustain, doneAction: Done.freeSelf)) // inverse FFT
}).add;
)
