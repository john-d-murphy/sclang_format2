// Source: Classes/VOsc3.schelp block 0 (part 5/7)
(
~bufs.do({ |buf, i|
	var a, n;
	n = (i+1)**2;
	a = Array.fill(n, { 1.0.rand2 });

	s.performList(\sendMsg, \b_gen, buf.bufnum, \sine1, 7, a);
});
)
