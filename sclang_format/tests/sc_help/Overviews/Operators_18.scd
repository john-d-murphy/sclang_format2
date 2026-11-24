// Source: Overviews/Operators.schelp block 18
(
{
	var a, b, c;
	a = Dseq([1, 2, 3, 4], inf).dpoll("a");
	b = Dseq([1955, 1952, 1823, 1452], inf).dpoll("b");
	c = (a <! b).dpoll("------> a <! b = "); // c only
	Duty.kr(0.4, 0, c);
	0.0
}.play
)
