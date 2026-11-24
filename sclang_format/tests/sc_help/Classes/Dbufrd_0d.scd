// Source: Classes/Dbufrd.schelp block 0 (part 4/10)
(
{ var indexPattern;
	indexPattern = Dseq([Dseq([0, 3, 5, 0, 3, 7, 0, 5, 9], 3), Dbrown(0, 23, 1, 5)], inf);
	SinOsc.ar(
		Demand.kr(Dust.kr(10), 0, Dbufrd(b, indexPattern))
	) * 0.1
}.play;
)
