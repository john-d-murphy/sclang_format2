// Source: Classes/Convolution2L.schelp block 4 (part 3/4)
(
// random impulse response
{
	var input, inputAmp, threshhold, gate;

	input = SoundIn.ar(0);
	inputAmp = Amplitude.kr(input);
	threshhold = 0.02;	// noise gating threshold
	gate = Lag.kr(inputAmp > threshhold, 0.01);

	Convolution2L.ar(input * gate, g, 0, a, 1, 0.5);
}.play
)
