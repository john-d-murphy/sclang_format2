// Source: Classes/KeyTrack.schelp block 1
(
{
	var in, fft, resample;
	var key, transientdetection;

	in = Mix(SinOsc.ar((60 + [0, MouseX.kr(3, 4).round(1), 7]).midicps, 0, 0.1));

	// major dom 7 and minor 7; major keys preferred here
	//in = Mix(SinOsc.ar((60 + (MouseY.kr(0, 11).round(1.0)) + [0, MouseX.kr(3, 4).round(1), 7, 10]).midicps, 0, 0.1));

	fft = FFT(LocalBuf(4096), in);  // for sampling rates 44100 and 48000

	key = KeyTrack.kr(fft);

	key.poll;

	Pan2.ar(in)
}.play
)
