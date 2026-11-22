// Source: Tutorials/A-Practical-Guide/PG_06b_Time_Based_Patterns.schelp block 1 (part 2/3)
(
p = Pbind(
		// using \note b/c Pseg will give fractional note numbers
		// can't use \degree because it handles non-integers differently
	\note, Pseg(
		Pwhite(-7, 19, inf),	// chromatic note numbers
			// alternate version for diatonic numbers
			// PdegreeToKey does the same conversion as \degree --> \note
//		PdegreeToKey(Pwhite(-4, 11, inf), Pkey(\scale), 12),
		Pwhite(1, 4, inf) * 0.5,
		5, inf),
	\dur, 0.125
).play;
)
