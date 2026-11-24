// Source: Tutorials/A-Practical-Guide/PG_06a_Repetition_Contraint_Patterns.schelp block 2 (part 1/2)
(
// in this case, the pattern stops by reaching maxdur
// elapsed time = 4
var	startTime;
p = (Psync(Pbind(
	\dur, 0.25,	// total duration = infinite
	\time, Pfunc { startTime = startTime ? (thisThread.clock.beats.debug("time")) }
), 1, 4) ++ Pfuncn({
	thisThread.clock.beats.debug("finish time");
	(thisThread.clock.beats - startTime).debug("elapsed");
	nil
}, 1)).play;
)
