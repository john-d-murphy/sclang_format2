// Source: Tutorials/A-Practical-Guide/PG_06g_Data_Sharing.schelp block 7 (part 1/2)
(
p = Penvir((), Ptpar([
	0.0, Pbind(
		\degree, Pwhite(0, 7, inf),
		\octave, 3,	// down 2 octaves
		\dur, Pwhite(1, 4, inf),
		\legato, 1,
		\amp, 0.2,
		\timingOffset, 0.1
	).collect({ |event|
		~lastBassEvent = event;
	}),
	0.1, Pbind(
		\topNote, Pseries(7, Prand(#[-2, -1, 1, 2], inf), inf).fold(2, 14),
		\bassTriadNotes, Pfunc { ~lastBassEvent[\degree] } + #[0, 2, 4],
		\merge, (Pkey(\topNote) - Pkey(\bassTriadNotes)) div: 7 * 7 + Pkey(\bassTriadNotes),
		\degree, Pfunc { |ev|
			if(ev[\merge].detect({ |item| item == ev[\topNote] }).isNil) {
				ev[\merge] ++ ev[\topNote]
			} {
				ev[\merge]
			}
		},
		\dur, Pwrand([Pseq([0.5, Pwhite(1, 3, 1), 0.5], 1), 1, 2, 3], #[1, 3, 2, 2].normalizeSum, inf),
		\amp, 0.05
	)
])).play;
)
