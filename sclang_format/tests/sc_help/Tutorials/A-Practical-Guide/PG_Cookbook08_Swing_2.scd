// Source: Tutorials/A-Practical-Guide/PG_Cookbook08_Swing.schelp block 2
(
Pchain(
	~swingify,
	Pbind(
		\degree, Pseries(-7, 1, 15),
		\dur, Pwrand([Pn(0.25, 2), Pn(1/6, 3)], [0.7, 0.3], inf)
	),
	(swingBase: 0.25, swingAmount: 0.2, swingThreshold: 0.05)
).play;
)
