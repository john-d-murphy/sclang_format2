// Source: Classes/Tdef.schelp block 3 (part 3/9)
(
Tdef(\x, {
	loop({
		s.sendMsg("/s_new", "pdef_grainlet", -1,0,0, \freq, rrand(600, 640));
		0.1.wait;
	})
})
)
