// Source: Classes/Group.schelp block 2 (part 7/19)
(
r = Routine({
	inf.do({
		l.do({ |node|
			node.set("freq", rrand(10, 120));
			1.0.wait;
		});
	})
});

r.play;
)
