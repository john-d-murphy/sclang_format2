// Source: Reference/randomSeed.schelp block 2 (part 1/2)
(
thisThread.randSeed = 1000;
TempoClock.sched(0, { 1000.rand.debug("main RNG"); 1 });

fork {
	2.1.wait;
	thisThread.randSeed = 1000;
	loop { 1000.rand.debug("routine RNG"); 1.wait }
};
)
