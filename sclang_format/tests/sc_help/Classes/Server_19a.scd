// Source: Classes/Server.schelp block 19 (part 1/2)
(
Routine.run {
	var c;

	// create a condition variable to control execution of the Routine
	c = Condition.new;

	s.bootSync(c);
	\BOOTED.postln;

	s.sendMsgSync(c, "/b_alloc", 0, 44100, 2);
	s.sendMsgSync(c, "/b_alloc", 1, 44100, 2);
	s.sendMsgSync(c, "/b_alloc", 2, 44100, 2);
	\b_alloc_DONE.postln;
};
)
