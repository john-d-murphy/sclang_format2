// Source: Classes/VOsc3.schelp block 0 (part 3/7)
(
~bufs.do({ |buf, i|
	var a;
	a = Array.fill(i, 0) ++ [0.5, 1, 0.5];
	s.performList(\sendMsg, \b_gen, buf.bufnum, \sine1, 7, a);
});
)
