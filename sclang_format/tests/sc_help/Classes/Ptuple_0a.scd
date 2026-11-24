// Source: Classes/Ptuple.schelp block 0 (part 1/4)
(
var a, b;
a = Pseq([1, 2, 3], inf);
b = Pseq([65, 76], inf);
c = Ptuple([a, a, b], inf);
x = c.asStream;
8.do({ x.next.postln });
)
