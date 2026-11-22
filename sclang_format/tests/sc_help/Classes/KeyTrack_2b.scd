// Source: Classes/KeyTrack.schelp block 2 (part 2/2)
(
{
	var in, fft, resample, chord, rootnote, sympath;
	var key, transientdetection;

	in = PlayBuf.ar(1, d, BufRateScale.kr(d), 1, 0, 1);

	fft = FFT(LocalBuf(4096), in);  // for sampling rates 44100 and 48000

	key = KeyTrack.kr(fft, 2.0, 0.5);
	key.poll;
	key = Median.kr(101, key); // Remove outlier wibbles

	chord = if(key < 12, #[0, 4, 7], #[0, 3, 7]);
	rootnote = if(key < 12, key, key-12) + 60;

	sympath = SinOsc.ar((rootnote + chord).midicps, 0, 0.4).mean;

	Pan2.ar(in, -0.5) + Pan2.ar(sympath, 0.5)
}.play
)
