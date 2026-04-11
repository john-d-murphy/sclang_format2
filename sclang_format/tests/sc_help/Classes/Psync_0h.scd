// Source: Classes/Psync.schelp block 0 (part 8/8)
(
b = Psync(a, 2);	// create a sequence of elements with a minimum of 2 beats,
			// but with undetermined upper limit
Ppar([
	Pseq([f, f, b, b], inf), // sequence
	Pbind(\instrument, \help_sinegrain, \freq, 1000, \sustain, 0.01, \dur, 2) // metronome
]).play;
)
