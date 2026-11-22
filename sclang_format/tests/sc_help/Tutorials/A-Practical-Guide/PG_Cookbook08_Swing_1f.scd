// Source: Tutorials/A-Practical-Guide/PG_Cookbook08_Swing.schelp block 1 (part 6/6)
(
q = Ppar([
	// walking bass (by a bass player who only chooses notes randomly)
	Pbind(
		\octave, 3,
		\degree, Pwhite(0, 7, inf),
		\dur, 0.5
	),
	Pseq([
		Pchain(
			~swingify,
			Pbind(
				\degree, Pseries(-7, 1, 15) +.x Pseq([0, 9], 1),
				\dur, Pwhite(1, 3, inf) * 0.25
			),
			(swingBase: 0.25, swingAmount: 0.2)
		),
		Pfuncn({ q.stop; Event.silent(1) }, 1)
	])
]).play;
)
