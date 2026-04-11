// Source: Classes/Padd.schelp block 2 (part 2/2)
(
a = Pbind(\dur, 0.5, \instrument, \sinegrain, \freq, 440);
b = Padd(\freq, Pseq([10, 30, 100], inf), a);
b.play;
)
