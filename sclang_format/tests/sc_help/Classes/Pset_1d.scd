// Source: Classes/Pset.schelp block 1 (part 4/4)
(
a = Pbind(\dur, 0.5, \instrument, \sinegrain);
a = Pset(\freq, Pseq([500, 600, 700], inf), a);
a = Pset(\legato, Pseq([0.01, 1],inf), a);
a.play;
)
