// Source: Classes/LinkClock.schelp block 1 (part 7/10)
(
q = nil;
c = SimpleController(l)
.put(\linkStart, {
	if(q.isNil) {
		q = Pbind(
			\degree, Pn(Pseries(0, 1, 8), inf),
			\dur, 0.25
		).play(l, quant: -1);
	}
})
.put(\linkStop, {
	q.stop;
	q = nil;
})
.put(\stop, { c.remove });  // clean up if clock stops
)
