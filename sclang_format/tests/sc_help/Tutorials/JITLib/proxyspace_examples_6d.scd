// Source: Tutorials/JITLib/proxyspace_examples.schelp block 6 (part 4/4)
(
~out = { var z, zz;
	z = Slope.ar(~out.ar);
	zz = Slope.ar(z);
	SinOsc.ar(Rand(300,410), z) *
	SinOsc.ar(zz * 410)
	* 0.1 + Decay2.ar(Pan2.ar(Dust.ar(600), MouseX.kr(-1,1)), 0.01, 0.05);
}
)
