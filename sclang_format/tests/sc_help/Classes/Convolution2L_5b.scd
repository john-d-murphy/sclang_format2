// Source: Classes/Convolution2L.schelp block 5 (part 2/3)
(
{
	var input = SoundIn.ar(0);
	var framesize = 512;
	Convolution2L.ar(input, b, 0, framesize, 1, 0.5);
}.play
)
