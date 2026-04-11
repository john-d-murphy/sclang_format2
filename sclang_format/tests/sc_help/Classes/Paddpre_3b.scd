// Source: Classes/Paddpre.schelp block 3 (part 2/2)
(
a = Pbind(\dur, 0.5, \instrument, \sinegrain);
b = Paddpre(\freq, Pseq([10, 30, 100], inf), a);
b.play;
)
