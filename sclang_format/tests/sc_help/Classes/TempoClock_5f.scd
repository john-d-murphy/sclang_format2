// Source: Classes/TempoClock.schelp block 5 (part 6/6)
(
r = Routine {
	// by addressing "this" clock,
	// we are always changing meter in the right place
	var clock = thisThread.clock;
	
	clock.beats.debug("start time");
	clock.timeToNextBeat(-1).wait;
	clock.beats.debug("barline");

	// no need to 'sched'
	// because the Routine is already on this clock
	// flip 3/4 -> 4/4 or 4/4 -> 3/4
	clock.beatsPerBar = 7 - clock.beatsPerBar;
	clock.beatsPerBar.debug("set meter to");

	0.01.wait;  // must be after barline for 'timeToNextBeat'
	clock.timeToNextBeat(-1).wait;
	clock.beats.debug("next barline");
}.play;
)
