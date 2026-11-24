// Source: Classes/Delay2.schelp block 0 (part 1/2)
(
{
	var z = Dust.ar(1000);
    // [ original, subtract delayed from original ]
	[z, z - Delay2.ar(z)]
}.plot(0.01)
)
