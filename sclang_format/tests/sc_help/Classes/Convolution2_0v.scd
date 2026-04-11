// Source: Classes/Convolution2.schelp block 0 (part 22/24)
(
// random impulse response

{
	var input,inputAmp,threshhold,gate;

	input = SoundIn.ar(0);
	inputAmp = Amplitude.kr(input);
	threshhold = 0.02;	// noise gating threshold
	gate = Lag.kr(inputAmp > threshhold, 0.01);

	Convolution2.ar(input*gate,g.bufnum,0, a, 0.5)
}.play;

)
