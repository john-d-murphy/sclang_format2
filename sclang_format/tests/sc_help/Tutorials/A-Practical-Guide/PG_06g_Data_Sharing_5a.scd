// Source: Tutorials/A-Practical-Guide/PG_06g_Data_Sharing.schelp block 5 (part 1/3)
(
TempoClock.default.tempo = 1;

~bass = Pbind(
	\degree, Pwhite(0, 7, inf),
	\octave, 3,	// down 2 octaves
	\dur, Pwhite(1, 4, inf),
	\legato, 1,
	\amp, 0.2
).collect({ |event|
	~lastBassEvent = event;
}).play(quant: Quant(quant: 1, timingOffset: 0.1));

// shorter form for the Quant object: #[1, 0, 0.1]

~chords = Pbind(
	\topNote, Pseries(7, Prand(#[-2, -1, 1, 2], inf), inf).fold(2, 14),
	\bassTriadNotes, Pfunc { ~lastBassEvent[\degree] } + #[0, 2, 4],
		// merge triad into topnote
		// raises triad notes to the highest octave lower than top note
		// div: is integer division, so x div: 7 * 7 means the next lower multiple of 7
	\merge, (Pkey(\topNote) - Pkey(\bassTriadNotes)) div: 7 * 7 + Pkey(\bassTriadNotes),
		// add topNote to the array if not already there
	\degree, Pfunc { |ev|
		if(ev[\merge].detect({ |item| item == ev[\topNote] }).isNil) {
			ev[\merge] ++ ev[\topNote]
		} {
			ev[\merge]
		}
	},
	\dur, Pwrand([Pseq([0.5, Pwhite(1, 3, 1), 0.5], 1), 1, 2, 3], #[1, 3, 2, 2].normalizeSum, inf),
	\amp, 0.05
).play(quant: 1);
)
