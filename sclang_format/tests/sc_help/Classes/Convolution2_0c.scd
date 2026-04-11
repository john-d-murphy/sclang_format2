// Source: Classes/Convolution2.schelp block 0 (part 3/24)
(
SynthDef("conv-test", { |out, kernel, trig = 0|
	var input;

	input = Impulse.ar(1);

	//must have power of two framesize
	Out.ar(out, Convolution2.ar(input, kernel, trig, 2048, 0.5));
}).add

)
