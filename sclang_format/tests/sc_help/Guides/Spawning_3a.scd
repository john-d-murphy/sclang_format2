// Source: Guides/Spawning.schelp block 3 (part 1/4)
(
Synth.play({
	Spawn.ar(
		{ EnvGen.ar(Env.perc) * SinOsc.ar(440,0,0.1) },
		1, // one channels
		1 // new event every second
	)
})
)
