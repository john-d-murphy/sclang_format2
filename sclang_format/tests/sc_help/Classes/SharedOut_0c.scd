// Source: Classes/SharedOut.schelp block 0 (part 3/4)
(
s.sendMsg(\s_new, "help-SharedOut", x = s.nextNodeID, 0, 1);
s.sendMsg(\n_trace, x);

// poll the shared control bus
Routine({
	30.do({
		s.getSharedControl(0).postln;
		0.2.wait;
	});
}).play;
)
