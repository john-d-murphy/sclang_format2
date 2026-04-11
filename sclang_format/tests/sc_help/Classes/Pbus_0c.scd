// Source: Classes/Pbus.schelp block 0 (part 3/4)
(
var p, q, r, o;
p = Pbind(\degree, Prand((0..7),12), \dur, 0.3, \legato, 0.2);

q = Pfx(p, \echo, \dtime, 0.2, \decay, 3);

r = Pfx(q, \distort, \pregain, 20, \amp, 0.25);

o = Pfx(r, \wah);

Ppar(
	[p, q, r, o].collect(Pbus(_)); // play each in a different bus.
).play;
)
