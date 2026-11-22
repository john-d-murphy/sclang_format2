// Source: Tutorials/A-Practical-Guide/PG_06a_Repetition_Contraint_Patterns.schelp block 2 (part 2/2)
(
// in this case, the pattern stops itself before maxdur (4)
// the Pbind's duration (1.25) gets rounded up to 2 (next multiple of 1)
var	startTime;
p = (Psync(Pbind(
	\dur, Pn(0.25, 5),	// total duration = 0.25 * 5 = 1.25
	\time, Pfunc { startTime = startTime ? (thisThread.clock.beats.debug("time")) }
), 1, 4) ++ Pfuncn({
	thisThread.clock.beats.debug("finish time");
	(thisThread.clock.beats - startTime).debug("elapsed");
	nil
}, 1)).play;
)
