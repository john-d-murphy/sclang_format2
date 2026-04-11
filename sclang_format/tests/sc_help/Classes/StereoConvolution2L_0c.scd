// Source: Classes/StereoConvolution2L.schelp block 0 (part 3/14)
(
SynthDef(\conv_test, { |out, kernel1, kernel2, t_trig = 0|
	var input, result, framesize;
	framesize = 2048; // must be a power of two
	input = Impulse.ar(1);
	result = StereoConvolution2L.ar(input, kernel1, kernel2, t_trig, framesize, 1, 0.5);
	Out.ar(out, result);
}).add
)
