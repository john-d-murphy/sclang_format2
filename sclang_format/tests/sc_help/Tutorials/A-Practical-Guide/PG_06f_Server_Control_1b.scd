// Source: Tutorials/A-Practical-Guide/PG_06f_Server_Control.schelp block 1 (part 2/3)
(
p = Ppar([
	Pfxb(Pbind(
		\degree, Pseq([0, 7, 4, 3, 9, 5, 1, 4], inf),
		\octave, 4,
		\dur, 0.5
	), \volumeCtl, \amp, ~vbus1.asMap),	// map to control bus here
	Pfxb(Pbind(
		\degree, Pwhite(0, 11, inf),
		\dur, 0.25
	), \volumeCtl, \amp, ~vbus2.asMap)	// ... and here
]).play;
)
