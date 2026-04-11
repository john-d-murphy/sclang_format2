// Source: Classes/Prorate.schelp block 0 (part 3/5)
(
a = Prorate(Pseq([[1, 2], [5, 7], [4, 8, 9]]).collect(_.normalizeSum), 1);
x = a.asStream;
x.nextN(8)
)
