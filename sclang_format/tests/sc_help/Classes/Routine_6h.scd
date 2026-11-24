// Source: Classes/Routine.schelp block 6 (part 8/10)
(
t = PauseStream(Routine {
	var lastSeconds = thisThread.seconds;
	loop {
		1.0.wait;
		[thisThread.beats, thisThread.seconds - lastSeconds].postln;
		lastSeconds = thisThread.seconds;
	}
}).play;
)
