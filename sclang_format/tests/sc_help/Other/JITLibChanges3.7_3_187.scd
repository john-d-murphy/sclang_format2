// Source: Other/JITLibChanges3.7.schelp block 3 (part 188/248)
(
Pdef.clear;

Pdef(\p, Pbind(\degree, Prand((0..7),12), \dur, 0.3 / Pseq([1, 1, 1, 2, 3, 1, 1, 3, 1, 1], inf), \legato, 0.2));

Pdef(\q, Pfxb(Pdef(\p), \echo, \dtime, 0.2, \decay, 3));

Pdef(\r, Pfxb(Pdef(\q), \distort, \pregain, 20, \amp, 0.25));

Pdef(\o, Pfxb(Pdef(\r), \wah, \rq, 0.2));

Pdef(\out, Pseq([Pdef(\p), Pdef(\q), Pdef(\r), Pdef(\o)], inf)).play;
)
