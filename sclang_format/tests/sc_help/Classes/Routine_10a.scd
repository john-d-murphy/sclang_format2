// Source: Classes/Routine.schelp block 10 (part 1/5)
(
r = Routine { |inval|
	loop {
		// thisThread refers to the routine.
		postf("beats: % seconds: % time: % \n",
			thisThread.beats, thisThread.seconds, Main.elapsedTime
		);
		1.0.yield;

	}
}.play;
)
