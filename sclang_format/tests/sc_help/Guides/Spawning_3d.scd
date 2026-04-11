// Source: Guides/Spawning.schelp block 3 (part 4/4)
(
r = Routine.new({ { Synth.new("help-EnvGen"); 1.yield; }.loop }); // loop every one second
SystemClock.play(r);
)
