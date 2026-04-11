// Source: Classes/Pnaryop.schelp block 0 (part 3/6)
(
var a;
a = Pnaryop(\wrap, Pseries(0, 1, 12), [Pseq([3, 4, 5], inf), Pseq([9, 7], inf)]);
a.asStream.all;
)
