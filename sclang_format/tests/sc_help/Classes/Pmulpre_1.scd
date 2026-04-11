// Source: Classes/Pmulpre.schelp block 1
(
var a, b;
a = Pmulpre(\freq, 801, Pset(\freq, 500, Pbind(\dur, 0.2)));
x = a.asStream;
9.do({ x.next(Event.default).postln; });
)
