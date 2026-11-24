// Source: Classes/VOsc3.schelp block 0 (part 4/7)
(
~bufs.do({ |buf, i|
	var a, n;
	n = (i+1)*8;
	a = Array.fill(n, 0);
	(n>>1).do({ |i| a.put(n.rand, 1) });

	s.performList(\sendMsg, \b_gen, buf.bufnum, \sine1, 7, a);
});
)
