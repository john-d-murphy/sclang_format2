// Source: Classes/Pavaroh.schelp block 0 (part 3/3)
(
	var aroh, avaroh, synth, str, pat;

	//gandhari raga.  vadi: dha (7) samvadi: ga (3)

	aroh = #[0, 2, 5, 7, 10];
	avaroh =  #[0, 1, 3, 5, 7, 9, 10];

	synth = Synth.head(s, \ivg);
	pat = Prand([0, 2, 3, 4, 2, 1, 0, -1, -2], inf);
	str = Pavaroh(pat, aroh, avaroh).asStream;
	Routine({

		loop({
			synth.set(\freq, midicps(str.next + 60) );
			rrand([0.1,1.0].choose, 0.5).wait;
		});

	}).play;
)
