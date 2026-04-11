// Source: Classes/PartConv.schelp block 0 (part 4/6)
(
{
	var input = SoundIn.ar(0);
	PartConv.ar(input, ~fftsize, ~irspectrum.bufnum)
}.play
)
