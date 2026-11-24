// Source: Tutorials/A-Practical-Guide/PG_06e_Language_Control.schelp block 2 (part 1/2)
(
~go = true;
p = Pwhile({ ~go }, Pbind(
	\degree, Pseries({ rrand(-7, 0) }, Pwhite(1, 3, inf), { rrand(4, 10) })
		.trace(prefix: "degree: "),
	\dur, 0.25
)).play;
)
