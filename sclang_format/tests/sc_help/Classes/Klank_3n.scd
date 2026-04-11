// Source: Classes/Klank.schelp block 3 (part 14/14)
(
a = Synth(\help_Klank, [
	\i_freq, 500,
	\harm, [4, 1, 3, 5, 7],
	\ring, Array.fill(4, 0.1), // set shorter ring time
	\amp, Array.fill(4, 0.2) // set louder amps
])
);
