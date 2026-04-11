// Source: Classes/Prewrite.schelp block 1 (part 1/2)
(
// Scale degrees going up
Pdef(\a, Pbind(\dur, 0.25, \degree, Pseq((0..3))));

// Scale degrees going down
Pdef(\b, Pbind(\dur, 0.25, \degree, Pseq((3..0))));

// Random scale degrees
Pdef(\c, Pbind(\dur, 0.125, \degree, Pwhite(0,10, 8)));

// Use the L-system to put together a sequence of keys
// Psym will then retrieve the patterns from the global Pdef dictionary
// See the post window for info about which of these are playing
Psym(
	Prewrite(\a, // start with pattern \a
		(
			\a: #[\a, \b],
			\b: #[\c, \a],
			\c: #[\a, \b]
	), 4).trace
).play
)
