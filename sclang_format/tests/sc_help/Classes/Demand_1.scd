// Source: Classes/Demand.schelp block 1
{
var a, b, t = Impulse.kr(2);
a = { Dseq([1, 2, 3, 4, 5], inf) } * 100;
b = a + 1;
Demand.kr(t, 0, [a, b]).poll(t)
}.play
