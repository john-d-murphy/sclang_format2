// Source: Classes/Ptuple.schelp block 0 (part 2/4)
(
var a, b;
a = Pseq([1, 2, 3], inf);
b = Pseq([65, 76], 3); // stops after 3 cycles
c = Ptuple([a, a, b], 4); // stops after 4 cycles
x = c.asStream;
8.do({ x.next.postln });
)
