// Source: Tutorials/Server_Tutorial.schelp block 17
(
s.sendBundle(0.2,
	["/s_new", "sine", x = s.nextNodeID, 1, 1, "freq", 800],
	["/s_new", "sine", y = s.nextNodeID, 1, 1, "freq", 1001],
	["/s_new", "sine", z = s.nextNodeID, 1, 1, "freq", 1202]);
s.sendBundle(1.2, ["/n_free", x],["/n_free", y],["/n_free", z]);
)
