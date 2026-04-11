// Source: Classes/Convolution.schelp block 0 (part 3/3)
(

// random impulse response

g.set(0, 1.0);

100.do({ arg i; g.set(a.rand, 1.0.rand) });


{
	var input, kernel;

	input = SoundIn.ar(0);
	kernel = PlayBuf.ar(1, g.bufnum,BufRateScale.kr(g.bufnum), 1, 0, 1);

	Convolution.ar(input, kernel, 2 * a, 0.5)
}.play;

)
