// Source: Classes/MantissaMask.schelp block 0 (part 3/6)
(
{
	var in;
	in = SinOsc.ar(SinOsc.kr(0.2, 0, 400, 500), 0, 0.4);
	in - MantissaMask.ar(in, 3)
}.play
)
