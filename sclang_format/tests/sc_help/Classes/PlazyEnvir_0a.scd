// Source: Classes/PlazyEnvir.schelp block 0 (part 1/4)
(
a = PlazyEnvir({ |a = 0, b = 1| Pshuf([a, a, b], 2) }); // a, b default to 0, 1
x = Pn(a, inf).asStream;

10.do { x.next.postln }; Post.nl;
e = (a: 100);
10.do { x.next(e).postln }; Post.nl;
e = (a: 100, b: 200);
10.do { x.next(e).postln };
)
