// Source: Classes/Delay2.schelp block 0
(
plot({
	var z;
	z = Dust.ar(1000);
	[z, z - Delay2.ar(z)] 	// [ original, subtract delayed from original ]
}))
