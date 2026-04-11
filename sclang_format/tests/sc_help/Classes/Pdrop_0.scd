// Source: Classes/Pdrop.schelp block 0
(
p = Pdrop(2, Pseq([1,2,3,4],6));
q = p.asStream.nextN(20).postln;
)
