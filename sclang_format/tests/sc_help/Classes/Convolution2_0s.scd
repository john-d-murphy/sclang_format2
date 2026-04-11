// Source: Classes/Convolution2.schelp block 0 (part 19/24)
(
	{ var input, kernel;

	input=SoundIn.ar(0);

	//must have power of two framesize
	Out.ar(0,Convolution2.ar(input,b.bufnum,0,512, 0.5));
	 }.play;

)
