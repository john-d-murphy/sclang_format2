// Source: Classes/Slew.schelp block 0 (part 1/2)
(
{
	z = LFPulse.ar(800);
	[z, Slew.ar(z, 4000, 4000)]
}.plot)
