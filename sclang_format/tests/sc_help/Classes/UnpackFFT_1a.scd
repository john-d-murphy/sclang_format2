// Source: Classes/UnpackFFT.schelp block 1 (part 1/2)
(
{
	var sig, chain, stream, windowStarts, fftSize;
	fftSize = 1024;

	sig = SinOsc.ar(LFDNoise3.kr(LFNoise0.kr(1) * 40 + 60) * 700 + 800);
	chain = FFT(LocalBuf(1, fftSize), sig);

	// a window start is indicated by a signal leaving the -1 bottom line
	windowStarts = chain > -1;

	// Using the frombin & tobin args makes it much more efficient, limiting analysis to the bins of interest
	stream = UnpackFFT(chain, fftSize, frombin: 0, tobin: 4);

	// Demand some data from the unpacker.
	// NOTE: At present, Demand.kr is unable to handle more than 32 inputs,
	// so using frombin & tobin to limit the number of bins is compulsory.

	Demand.kr(windowStarts, 0, stream).collect { |anunp, index|
		var label = if(index.even) { "Magnitude" } { "Phase" };
		label = label + (index / 2).floor;
		anunp.poll(windowStarts, label)
	};

	sig * 0.05
}.play
)
