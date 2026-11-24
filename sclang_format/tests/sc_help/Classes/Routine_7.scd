// Source: Classes/Routine.schelp block 7
(
r = Routine { "hi".yield; "bye".yield };
r.next.postln;    // "hi" posted

q = r.p.asStream; // or just: r.p.iter
q.next.postln;    // "hi" again

r.next.postln;    // "bye" because r kept its own state, separate from q
)
