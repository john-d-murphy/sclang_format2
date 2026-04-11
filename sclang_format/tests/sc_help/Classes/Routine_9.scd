// Source: Classes/Routine.schelp block 9
(
r = (:2..6);
Pseq([r, r]).asStream.all.postln;
// [ 2, 3, 4, 5, 6 ]

p = r.p;
Pseq([p, p]).asStream.all.postln;
// [ 2, 3, 4, 5, 6, 2, 3, 4, 5, 6 ]

Pseq([(:2..6), (:2..6)]).asStream.all.postln;
// [ 2, 3, 4, 5, 6, 2, 3, 4, 5, 6 ]
)
