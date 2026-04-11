// Source: Tutorials/Streams-Patterns-Events3.schelp block 17 (part 1/2)
(
SynthDef( \help_SPE3_Allpass6, { arg freq;
	var out, env;
	out = RLPF.ar(
		LFSaw.ar( freq, mul: EnvGen.kr( Env.perc, levelScale: 0.3, doneAction: Done.freeSelf ) ),
		LFNoise1.kr(1, 36, 110).midicps,
		0.1
	);
	6.do({ out = AllpassN.ar(out, 0.05, [0.05.rand, 0.05.rand], 4) });
	Out.ar( 0, out );
}).add
)
