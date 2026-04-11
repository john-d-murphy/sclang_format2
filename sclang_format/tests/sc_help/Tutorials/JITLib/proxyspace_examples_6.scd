// Source: Tutorials/JITLib/proxyspace_examples.schelp block 6
~out = { SinOsc.ar([220, 330], ~out.ar(2).reverse * LFNoise2.kr(0.5, 4pi), 0.4) };

// there is no immediacy: hear the buffer size cycle
~out = { Impulse.ar(1 ! 2) + (~out.ar(2) * 0.99) };



// SuperCollider 'differential equations'

~out = { SinOsc.ar(Slope.ar(~out.ar) * MouseX.kr(1000, 18000, 1)) * 0.1 + SinOsc.ar(100, 0, 0.1) };

(
~out = { var z, zz;
	z = Slope.ar(~out.ar);
	zz = Slope.ar(z);
	SinOsc.ar(Rand(300,410), z) *
	SinOsc.ar(zz * 410)
	* 0.1 + Decay2.ar(Pan2.ar(Dust.ar(600), MouseX.kr(-1,1)), 0.01, 0.05);
}
)
