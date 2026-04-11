// Source: Classes/Pfuncn.schelp block 0
(
var a, b, c;
a = Pfuncn({ exprand(0.1, 2.0) + #[1, 2, 3, 6].choose }, 2);
b = Pfuncn({ #[-2, -3].choose }, 2);
Pseq([a, b], inf).asStream.nextN(20).postln;
)
