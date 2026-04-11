// Source: Classes/Psetpre.schelp block 1 (part 4/4)
(
a = Pbind(\dur, 0.5, \instrument, \sinegrain);
a = Psetpre(\freq, Pseq([500, 600, 700], inf), a);
a = Psetpre(\legato, Pseq([0.01, 1],inf), a);
a.play;
)
