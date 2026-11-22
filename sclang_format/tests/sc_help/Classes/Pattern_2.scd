// Source: Classes/Pattern.schelp block 2
(
	a = [3, Pseq([-100, 00, 300, 400]), Pseq([-100, 00, 300, 400].reverse)];

	r = Routine({ a.do({ |v| v.embedInStream }) }) ;
	p = Pseq(a);
	q = p.asStream;
	10.do({ Post << Char.tab << r.next << " " << q.next << Char.nl });
)
