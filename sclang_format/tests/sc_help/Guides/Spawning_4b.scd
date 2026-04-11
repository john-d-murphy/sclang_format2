// Source: Guides/Spawning.schelp block 4 (part 2/2)
(
t = TempoClock.new;
r = Routine.new({
	10.do({
		// could be done with an argument instead of a new def, but proves the point
		SynthDef("help-EnvGen" ++ i, { arg out = 0;
			Out.ar(
				out,
				EnvGen.kr(Env.perc, 1.0, doneAction: Done.freeSelf)
				* SinOsc.ar(100 + (100 * t.elapsedBeats), 0, 0.1)
			)
		}).play(s);
		1.yield;
	});
}).play(t); // Note the alternative syntax: Routine.play(aClock)
)
