// Source: Classes/Pset.schelp block 0
(
var a, b;
a = Pset(\freq, 801, Pbind(\dur, 0.5));
x = a.asStream;
9.do({ x.next(Event.new).postln; });
)
