// Source: Classes/Routine.schelp block 8
(
r = (:2..5); // a seriesIter Routine
Ptuple([r, r]).asStream.all.postln; // posts [ [ 2, 3 ], [ 4, 5 ] ]
r.next.postln; // nil

p = r.p; // make a Pattern from r; it doesn't matter that r has ended
Ptuple([p, p]).asStream.all.postln;
// posts [ [ 2, 2 ], [ 3, 3 ], [ 4, 4 ], [ 5, 5 ] ]

// Obviously, explicitly writing the same Routine-valued subexpression twice
// also creates separate Routines.
Ptuple([(:2..5), (:2..5)]).asStream.all.postln;
// posts [ [ 2, 2 ], [ 3, 3 ], [ 4, 4 ], [ 5, 5 ] ]
)
