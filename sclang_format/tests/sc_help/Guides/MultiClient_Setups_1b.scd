// Source: Guides/MultiClient_Setups.schelp block 1 (part 2/4)
r = Server(
	\remote4,
	// example NetAddr of the machine that runs scsynth on standard port
	NetAddr("168.192.1.2", 57110),
	s.options,		// make sure all remote servers use the same options
	4				// and when desired, set fixed client by hand
);
