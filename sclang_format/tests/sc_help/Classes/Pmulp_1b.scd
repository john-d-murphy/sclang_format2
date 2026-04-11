// Source: Classes/Pmulp.schelp block 1 (part 2/2)
(
a = Pbind(\freq, Pseq([500, 600, 700]), \instrument, \sinegrain);
a = Pmulp(\freq, Pseq([0.5, 0.9, 0.8], inf), a);
a.play;
)
