// Source: Classes/Delay1.schelp block 0
(
plot({
	var z;
	z = Dust.ar(1000);
	[z, z - Delay1.ar(z)] 	// [ original, subtract delayed from original ]
}))
