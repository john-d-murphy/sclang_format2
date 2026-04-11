// Source: Classes/Unpack1FFT.schelp block 0
(
{
	var sig, chain, stream, windowStarts, demand;
	var fftsize = 1024;

	sig = SinOsc.ar(LFDNoise3.kr(LFNoise0.kr(1) * 40 + 60) * 700 + 800);

	chain = FFT(LocalBuf(fftsize), sig);
	stream = Unpack1FFT(chain, bufsize: fftsize, binindex: 0, whichmeasure: 0);

	// each time an FFT window starts, the unpacker returns a new value
	windowStarts = chain > -1;
	demand = Demand.kr(windowStarts, 0, stream);
	demand.poll(windowStarts);

	sig * 0.05
}.play
)
