// Source: Classes/PartConv.schelp block 0 (part 5/6)
(
{
	var input = Impulse.ar(0.25);
	PartConv.ar(input, ~fftsize, ~irspectrum.bufnum)
}.play
)
