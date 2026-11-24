// Source: Classes/Prout.schelp block 0 (part 1/4)
(
var a;
a = Prout({ loop { 1.yield; 2.yield; 7.yield; 10.do { 1.0.rand.yield } } });
a.asStream.nextN(100).plot;
)
