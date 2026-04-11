// Source: Classes/Pprob.schelp block 0 (part 1/12)
(
var a = Pprob([0,0,0,0,1,1,1,1,3,3,6,6,9].scramble);
var b = a.asStream;
b.nextN(800).sort.plot("sorted distribution");
b.nextN(800).sort.plot("sorted distribution, again");
)
