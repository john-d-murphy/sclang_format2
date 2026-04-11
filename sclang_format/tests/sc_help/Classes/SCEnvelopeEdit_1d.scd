// Source: Classes/SCEnvelopeEdit.schelp block 1 (part 4/4)
(
Routine({
	var par, indices;
	indices = (2..21);
	loop({
		par = (indices +++ (
			v.env.levels ++
			v.env.times ++
			v.env.curves ++
			x.env.levels ++
			x.env.times ++
			x.env.curves)).flatten;
		s.sendBundle(s.latency, [\s_new, "sineBlip", -1, 1, 1, \freq, exprand(4e3,11e3)] ++ par);
		0.04.wait;
	});
}).play;
)
