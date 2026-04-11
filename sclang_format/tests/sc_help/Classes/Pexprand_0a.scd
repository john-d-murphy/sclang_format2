// Source: Classes/Pexprand.schelp block 0 (part 1/3)
(
var a;
a = Pexprand.new(0.0001, 1, inf);
c = a.asStream.nextN(500);
// plot the values
c.plot(bounds: Rect(10, 10, 520, 380), discrete: true, parent: w);
// a histogram of the values
c.histo(500).plot(bounds: Rect(10, 410, 520, 380), parent: w);
)
