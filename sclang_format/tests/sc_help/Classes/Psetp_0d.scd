// Source: Classes/Psetp.schelp block 0 (part 4/4)
(
a = Pbind(\dur, Pseq([0.5, 0.3, 0.1]), \instrument, \sinegrain);
a = Psetp(\freq, Pseq([500, 600, 700], inf), a);
a.play;
)
