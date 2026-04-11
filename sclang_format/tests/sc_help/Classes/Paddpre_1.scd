// Source: Classes/Paddpre.schelp block 1
(
var a, b;
a = Paddpre(\freq, 302, Pset(\freq, 500, Pbind(\dur, 0.3)));
x = a.asStream;
9.do({ x.next(Event.default).postln; });
)
