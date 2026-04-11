// Source: Classes/Pgauss.schelp block 0 (part 2/4)
(
var a, c, w;
a = Pgauss(0.0, 10.0, inf);
c = a.asStream.nextN(500);
w = Window.new("Pgauss", Rect(10, 10, 540, 800));
// plot the values
c.plot(bounds: Rect(10, 10, 520, 380), discrete: true, parent: w);
// a histogram of the values
c.histo(500).plot(bounds: Rect(10, 410, 520, 380), parent: w);
)
