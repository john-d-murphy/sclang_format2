// Source: Guides/FFT-Overview.schelp block 12 (part 1/2)
(
SynthDef("help-multichannel FFT", { |out=0| // bufnum is an array
	var in, chain;
	in = [SinOsc.ar(200, 0, 0.2), WhiteNoise.ar(0.2)];
	chain = FFT(LocalBuf([2048, 2048]), in); // each FFT has a different buffer
	// now we can multichannel expand as normal
	chain = PV_BrickWall(chain, SinOsc.kr(-0.1));

	Out.ar(out, IFFT(chain));
}).play;
)
