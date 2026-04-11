// Source: Classes/K2A.schelp block 0 (part 3/3)
(
{
	var freq, blockSize, sampleRate;
	blockSize = s.options.blockSize; // usually 64
	sampleRate = s.sampleRate;
	freq = MouseX.kr(0.1, 40, 1) / blockSize * sampleRate;
	[
		K2A.ar(LFNoise0.kr(freq)),
		LFNoise0.ar(freq)
	] * 0.3
}.scope;
)
