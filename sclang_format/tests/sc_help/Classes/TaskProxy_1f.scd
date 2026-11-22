// Source: Classes/TaskProxy.schelp block 1 (part 6/8)
(
y = TaskProxy {
	loop { s.sendMsg("/s_new", "pdef_grainlet", -1, 0, 0, \freq, 1500); 1.wait }
};
y.play;
)
