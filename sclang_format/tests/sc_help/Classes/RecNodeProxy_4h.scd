// Source: Classes/RecNodeProxy.schelp block 4 (part 8/10)
(
Routine({
	var id;
	loop({
		id = s.nextNodeID;
		s.sendMsg("/s_new", "default", id,0,0, \out, b, \freq, rrand(400, 800));
		0.2.wait;
		s.sendMsg("/n_set", id, \gate, 0);
		0.2.wait;
	})
}).play;
)
