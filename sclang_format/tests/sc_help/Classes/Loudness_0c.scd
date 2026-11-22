// Source: Classes/Loudness.schelp block 0 (part 3/3)
(
{
	var in, chain, loudness;

	in = SinOsc.ar(1000, 0, 0.001); // should be 1 sone
	// in = SinOsc.ar(1000, 0, 0.01); // should be 4 sone
	// in = SinOsc.ar(1000, 0, 0.1); // should be 16 sone
	// in = SinOsc.ar(1000, 0, 1); // should be 64 sone
	// in = Saw.ar * SinOsc.ar(4);
	// in = WhiteNoise.ar;
	// in = Silent.ar; // should be small, around 2 ** ((0 - 40) / 10) = 2 ** (-4) = 0.0625
	// in = DC.ar(1);
	// in = SinOsc.ar(22050, pi * 0.5, 1);
	// fade ins
	// in = SinOsc.ar(1000, 0, Line.kr(0, 1, 2));
	// in = SinOsc.ar(1000, 0, Line.kr(0, 1, 2) ** 2);
	// in = WhiteNoise.ar(Line.kr(0, 1, 2));
	// in = PlayBuf.ar(1, d, BufRateScale.kr(d), 1, 0, 1);

	chain = FFT(LocalBuf(1024).clear, in);  // for sampling rates 44100 and 48000
	// chain = FFT(LocalBuf(2048).clear, in);  // for sampling rates 88200 and 96000

	loudness = Loudness.kr(chain, 0.25, 6).poll(50);

	K2A.ar(loudness * 0.016)
}.plot(2.0)
)
