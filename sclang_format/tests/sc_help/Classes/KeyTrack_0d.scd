// Source: Classes/KeyTrack.schelp block 0 (part 4/4)
(
{
	var in, fft, resample;
	var key, transientdetection;

	in = PlayBuf.ar(1, d, BufRateScale.kr(d), 1, 0, 1);

	// With standard hop of half FFT size = 2048 samples
	fft = FFT(LocalBuf(4096), in);  // for sampling rates 44100 and 48000
	fft = FFT(LocalBuf(8192), in);   // for sampling rates 88200 and 96000

	key = KeyTrack.kr(fft, 2.0, 0.5);

	key.poll;

	Pan2.ar(in)
}.play
)
