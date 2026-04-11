// Source: Tutorials/A-Practical-Guide/PG_Cookbook01_Basic_Sequencing.schelp block 3 (part 2/4)
(
TempoClock.default.tempo = 1;

p = Pbind(
	\instrument, \stretchedFragments,
	\bufnum, b,
	\start, Pwhite(0, (b.numFrames * 0.7).asInteger, inf),
	\delta, Pexprand(0.2, 1.5, inf),
	\time, Pkey(\delta),
	\stretch, Pexprand(1.0, 4.0, inf),
	\amp, 0.5,
	\attack, 0.1,
	\decay, 0.2
).play;
)
