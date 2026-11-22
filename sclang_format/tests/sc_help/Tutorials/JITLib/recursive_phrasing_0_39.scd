// Source: Tutorials/JITLib/recursive_phrasing.schelp block 0 (part 40/45)
(
SynthDef(\play_from_to, { arg out, bufnum, from=0.0, to=1.0, sustain=1.0;
	var env;
	env = EnvGen.ar(Env.linen(0.01, sustain, 0.01), 1, doneAction: Done.freeSelf);
	Out.ar(out,
		BufRd.ar(1, bufnum,
			Line.ar(from, to, sustain) * BufFrames.kr(bufnum)
		) * env
	)


}).add;
)
