// Source: Guides/Spawning.schelp block 1
(
SystemClock.sched(2.0, {
	"2.0 seconds later".postln; // this could be any code, including Synth creation
	nil // this means don't repeat
});
)
