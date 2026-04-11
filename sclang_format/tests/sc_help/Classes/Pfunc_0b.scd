// Source: Classes/Pfunc.schelp block 0 (part 2/2)
(
x = Pfunc({ |inval| (10 ** inval.value) * rrand(1, 9) }).asStream;
[2, 3, 2].do { |i| x.next(i).postln };
x.nextN(5, (:0..)).postln;
)
