// Source: Tutorials/A-Practical-Guide/PG_03_What_Is_Pbind.schelp block 10 (part 2/3)
(
p = Pmono(\trig_demo,
	\freq, Pexprand(200, 800, inf),
	\trig, 1,	// note that this is NOT t_trig -- just \trig
	\delta, 0.125
).play;
)
