// Source: Classes/Dconst.schelp block 0 (part 1/2)
(
a = {
	var freq = Duty.kr(
		Dseq([
			Dconst(0.5, Dwhite(0.05, 0.08, inf)),
			0.5
		], inf),
		0,
		// workaround for the lack of Dexprand
		Dwhite(0, 1, inf).linexp(0, 1, 200, 600)
	);
	VarSaw.ar(Lag.kr(freq, 0.02), 0, 0.3, 0.1).dup
}.play;
)
