// Source: Classes/Paddp.schelp block 1 (part 2/2)
(
a = Pbind(\freq, Pseq([500, 600, 700]), \instrument, \sinegrain);
a = Paddp(\freq, Pseq([30, 90, -100], inf), a);
a.play;
)
