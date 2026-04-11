// Source: Tutorials/A-Practical-Guide/PG_07_Value_Conversions.schelp block 0 (part 1/2)
(
// approximate a major scale with a 19TET chromatic scale
p = Pbind(
	\scale, #[0, 3, 6, 8, 11, 14, 17],
	\stepsPerOctave, 19,
	\degree, Pwhite(0, 7, inf),
	\dur, 0.125,
	\legato, Pexprand(0.2, 6.0, inf)
).play;
)
