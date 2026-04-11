// Source: Guides/NodeMessaging.schelp block 6 (part 2/2)
(
Routine({
	20.do({
		s.sendMsg("/s_new", "grain", -1);
		0.01.wait;
	})
}).play;
)
