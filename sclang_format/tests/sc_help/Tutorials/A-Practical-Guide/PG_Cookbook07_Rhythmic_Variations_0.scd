// Source: Tutorials/A-Practical-Guide/PG_Cookbook07_Rhythmic_Variations.schelp block 0
~kik = Penvir(~kikEnvir, Pn(Plazy({
	~init.value;
	~addNotes.value;
	Pbindf(
		Pbind(
			\instrument, \kik,
			\preamp, 0.4,
			\dur, 0.25,
			*(~pbindPairs.value(#[amp, decay2]))
		),
		\freq, Pif(Pkey(\amp) > 0, 1, \rest)
	)
}), inf)).play(quant: 4);
