// Source: Classes/Pfxb.schelp block 0 (part 2/5)
(
var p, q, r, o;
p = Pbind(\degree, Prand((0..7),12), \dur, 0.3, \legato, 0.2);

q = Pfxb(p, \echo, \dtime, 0.2, \decay, 3);

r = Pfxb(q, \distort, \pregain, 20, \amp, 0.25);

o = Pfxb(r, \wah);

Pseq([p, q, r, o], 2).play;
)
