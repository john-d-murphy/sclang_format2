// Source: Tutorials/A-Practical-Guide/PG_06e_Language_Control.schelp block 0 (part 1/2)
p = Pbind(
	\degree, Pwhite(0, 11, inf),
		// odd numbered scale degrees get a shorter rhythmic value
	\dur, Pif(Pkey(\degree).odd, 0.25, 0.5)
).play;
