// Source: Classes/Convolution2L.schelp block 2 (part 1/11)
(
SynthDef(\conv_test2, { |out, kernel, t_trig=0|
	var input = Impulse.ar(1);
	var framesize = 2048; // must have power of two
	var result = Convolution2L.ar(input, kernel, t_trig, 2048, 5, 0.5);
	Out.ar(out, result);
}).add
)
