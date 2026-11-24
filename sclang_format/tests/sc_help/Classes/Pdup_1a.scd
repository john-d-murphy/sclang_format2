// Source: Classes/Pdup.schelp block 1 (part 1/10)
(
var a, b;
a = Pdup(Prand([1, 2, 5], inf), Pwhite(-1.0, 1.0)); // repeat either once, twice, or five times
x = a.asStream;
20.do { x.next.postln };
)
