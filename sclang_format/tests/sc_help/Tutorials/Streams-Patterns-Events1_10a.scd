// Source: Tutorials/Streams-Patterns-Events1.schelp block 10 (part 1/2)
(
	s = Server.local;
	SynthDef(\help_SPE1, { arg i_out=0, freq;
		var out;
		out = RLPF.ar(
			LFSaw.ar( freq, mul: EnvGen.kr( Env.perc, levelScale: 0.3, doneAction: Done.freeSelf )),
			LFNoise1.kr(1, 36, 110).midicps,
			0.1
		);
		// out = [out, DelayN.ar(out, 0.04, 0.04) ];
		4.do({ out = AllpassN.ar(out, 0.05, [0.05.rand, 0.05.rand], 4) });
		Out.ar( i_out, out );
	}).send(s);
)
