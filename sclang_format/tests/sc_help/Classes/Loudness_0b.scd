// Source: Classes/Loudness.schelp block 0 (part 2/3)
(
{
	var in = PlayBuf.ar(1, d, BufRateScale.kr(d), 1, 0, 1);
	var chain = FFT(LocalBuf(1024).clear, in);  // for sampling rates 44100 and 48000
	// var chain = FFT(LocalBuf(2048).clear, in);  // for sampling rates 88200 and 96000
	var loudness = Loudness.kr(chain).poll(50);
	Pan2.ar(in)
}.play
)
