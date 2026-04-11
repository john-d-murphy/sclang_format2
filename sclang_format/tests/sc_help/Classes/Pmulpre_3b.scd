// Source: Classes/Pmulpre.schelp block 3 (part 2/2)
(
a = Pbind(\dur, 0.5, \instrument, \sinegrain);
b = Pmulpre(\freq, Pseq([1, 2, 3], inf), a);
b.play;
)
