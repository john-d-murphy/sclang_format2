// Source: Tutorials/A-Practical-Guide/PG_Cookbook08_Swing.schelp block 1 (part 5/6)
(
Ppar([
	// 60% of a 16th-note
	Pchain(~swingify, p, (swingBase: 0.25, swingAmount: 0.6, pan: -1)),
	// 20% of a 16th-note
	Pchain(~swingify, p, (swingBase: 0.25, swingAmount: 0.2, pan: 1, octave: 6))
]).play;
)
