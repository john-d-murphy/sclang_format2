// Source: Classes/SharedIn.schelp block 0 (part 3/4)
(
s.setSharedControl(0, 300); // an initial value
s.sendMsg(\s_new, "help-SharedIn1", x = s.nextNodeID, 0, 1);
s.sendMsg(\s_new, "help-SharedIn2", y = s.nextNodeID, 0, 1);

Routine({
	30.do({
		s.setSharedControl(0, 300 * (10.rand + 1));
		0.2.wait;
	});
	s.sendMsg(\n_free, x);
	s.sendMsg(\n_free, y);
}).play;
)
