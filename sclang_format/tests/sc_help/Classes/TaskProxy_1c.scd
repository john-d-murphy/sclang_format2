// Source: Classes/TaskProxy.schelp block 1 (part 3/8)
(
x.source = {
	loop {
		s.sendMsg("/s_new", "pdef_grainlet", -1, 0, 0, \freq, rrand(600, 640));
		0.1.wait;
	}
}
)
