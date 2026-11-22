// Source: Tutorials/A-Practical-Guide/PG_03_What_Is_Pbind.schelp block 9 (part 1/2)
(
// first, pitches ascending by 1-3 semitones, until 2 octaves are reached
var	pitches = Pseries(0, Pconst(24, Pwhite(1, 3, inf)), inf).asStream.all,
		// randomly block 1/3 of those
	mask = pitches.scramble[0 .. pitches.size div: 3];

p = Pbind(
	\arpeg, Pseq(pitches[ .. pitches.size - 2] ++ pitches.reverse[ .. pitches.size - 2], inf),
		// if the note is found in the mask array, replace it with Rest
		// then that note does not sound
	\note, Pif(Pfunc { |event| mask.includes(event[\arpeg]) }, Rest(0), Pkey(\arpeg)),
	\octave, 4,
	\dur, 0.125
).play;
)
