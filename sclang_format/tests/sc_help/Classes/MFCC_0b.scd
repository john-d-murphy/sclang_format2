// Source: Classes/MFCC.schelp block 0 (part 2/6)
(
x = {
	var in, fft, array;

	// in = PlayBuf.ar(1, d, BufRateScale.kr(d), 1, 0, 1);

	in = SoundIn.ar(0);
	fft = FFT(LocalBuf(1024), in);  // for sampling rates 44100 and 48000
	// fft = FFT(LocalBuf(2048), in);  // for sampling rates 88200 and 96000

	array = MFCC.kr(fft);

	array.size.postln;

	Out.kr(0, array); // control bus out
	Out.ar(0, Pan2.ar(in)); // audio bus out
}.play
)
