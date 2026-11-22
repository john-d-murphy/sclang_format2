// Source: Classes/Pattern.schelp block 1
(
	var routinesA;
	a = [3, Pseq([-100, 00, 300, 400]), Pseq([-100, 00, 300, 400].reverse)];
	routinesA = [[3], [-100, 00, 300, 400], [-100, 00, 300, 400].reverse];
	p = Pseq(a);
	q = p.asStream;

	r = Routine({
		routinesA.do({ |v|
			v.do({ |i| i.yield })
		}) ;
	});
	10.do({ Post << Char.tab << r.next << " " << q.next << Char.nl });
)
