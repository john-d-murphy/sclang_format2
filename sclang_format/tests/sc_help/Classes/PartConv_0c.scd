// Source: Classes/PartConv.schelp block 0 (part 3/6)
(
{
	var input = PlayBuf.ar(1, ~target, loop:1);
	PartConv.ar(input, ~fftsize, ~irspectrum.bufnum, 0.5)
}.play
)
