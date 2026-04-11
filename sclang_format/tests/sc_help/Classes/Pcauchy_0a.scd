// Source: Classes/Pcauchy.schelp block 0 (part 1/4)
(
var a, c, w;
a = Pcauchy(0.0, 1.0, inf);
c = a.asStream.nextN(500);
w = Window.new("Pcauchy", Rect(10, 10, 540, 800));
// plot the values
c.plot(bounds: Rect(10, 10, 520, 380), discrete: true, parent: w);
// a histogram of the values
c.histo(500).plot(bounds: Rect(10, 410, 520, 380), parent: w);
)
