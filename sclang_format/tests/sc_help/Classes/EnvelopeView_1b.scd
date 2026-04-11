// Source: Classes/EnvelopeView.schelp block 1 (part 2/2)
(
r = Routine({
	var j = 0;
	20.do({ arg i;
		b.selectIndex((b.size - 1).rand.abs);
		0.1.wait;
		b.x_(1.0.rand.abs);
		b.y_(1.0.rand.abs);
	});
	b.selectIndex(-1);
});
AppClock.play(r);
)
