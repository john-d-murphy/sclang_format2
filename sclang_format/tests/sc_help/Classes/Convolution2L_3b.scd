// Source: Classes/Convolution2L.schelp block 3 (part 2/2)
(
{
	var input = SoundIn.ar(0);
	var framesize = 2048; // must have power of two
	Convolution2L.ar(input, b, 0, 512, 1, 0.5);
}.play
)
