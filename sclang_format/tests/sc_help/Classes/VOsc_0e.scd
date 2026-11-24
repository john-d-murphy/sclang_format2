// Source: Classes/VOsc.schelp block 0 (part 5/6)
(
~bufs.do({ |buf, i|
	var a = Array.fill((i+1)**2, { |j| 1.0.rand2 });
	s.performList(\sendMsg, \b_gen, buf.bufnum, \sine1, 7, a);
});
)
