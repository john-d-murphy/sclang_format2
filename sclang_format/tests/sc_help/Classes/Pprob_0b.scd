// Source: Classes/Pprob.schelp block 0 (part 2/12)
(
var a, b, x, y;
a = Pprob([1, 0]);
x = Pfunc({ 1.0.linrand });

b = a.asStream;
y = x.asStream;

postf("Pprob mean: % linrand mean: % \n", b.nextN(800).mean, y.nextN(800).mean);

b.nextN(800).sort.plot("this is Pprob");
y.nextN(800).sort.plot("this is linrand");
)
