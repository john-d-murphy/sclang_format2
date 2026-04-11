// Source: Classes/Pmul.schelp block 2 (part 2/2)
(
a = Pbind(\dur, 0.5, \instrument, \sinegrain, \freq, 440);
b = Pmul(\freq, Pseq([1, 2, 3, 4, 5, 6, 7], inf), a);
b.play;
)
