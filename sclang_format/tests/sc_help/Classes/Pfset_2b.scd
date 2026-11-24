// Source: Classes/Pfset.schelp block 2 (part 2/2)
(
a = Pbind(\dur, 0.5, \instrument, \sinegrain, \x, Pfunc { rrand(500, 600) });
a = Pfset({ ~freq = { ~x.postln * 2 }; ~legato = 3 }, a);
a.play;
)
