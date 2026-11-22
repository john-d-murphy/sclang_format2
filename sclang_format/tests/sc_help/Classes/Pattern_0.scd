// Source: Classes/Pattern.schelp block 0
(
	a = [-100, 00, 300, 400];			// the array to iterate

	p = Pseq(a);					// make the Pattern
	q = p.asStream;					// have the Pattern make a Stream
	r = Routine({ a.do({ |v| v.yield }) }) ;	// make the Stream directly

	5.do({ Post << Char.tab << r.next << " " << q.next << Char.nl });
)
