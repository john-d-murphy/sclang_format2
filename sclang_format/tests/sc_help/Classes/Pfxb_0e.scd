// Source: Classes/Pfxb.schelp block 0 (part 5/5)
(
var a;
a = Pbind(\degree, Prand((0..7),12), \dur, 0.3, \legato, 0.2);
a = Pfxb(a, \addbeeps);
a = Pfxb(a, \echo, \dtime, 0.2, \decay, 3);
a.play;
)
