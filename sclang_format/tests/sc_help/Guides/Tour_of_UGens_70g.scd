// Source: Guides/Tour_of_UGens.schelp block 70 (part 7/8)
(
// randomly generated envelope
z = { arg gate=1;
	var env, n=32;
	env = Env(
				[0]++{1.0.rand.squared}.dup(n-1) ++ [0],
				{rrand(0.005,0.2)}.dup(n),
				\lin, n-8, 8 );
	EnvGen.kr(env, gate, doneAction: Done.freeSelf) * LFTri.ar(220,0,0.4)
}.scope(1, zoom:4);
)
