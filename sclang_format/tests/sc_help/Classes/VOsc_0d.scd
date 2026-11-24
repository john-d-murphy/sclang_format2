// Source: Classes/VOsc.schelp block 0 (part 4/6)
(
~bufs.do({ |buf, i|
	var a = Array.fill(32, 0);
	12.do({ |i| a.put(32.rand, 1) });
	s.performList(\sendMsg, \b_gen, buf.bufnum, \sine1, 7, a);
});
)
