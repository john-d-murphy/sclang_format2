// Source: Classes/TaskProxy.schelp block 1 (part 4/8)
(
x.source = {
	var x;
	x = Pseries(300, 20, 100).loop.asStream;
	loop {
		s.sendMsg("/s_new", "pdef_grainlet", -1, 0, 0, \freq, x.next);
		0.05.wait;
	}
}
)
