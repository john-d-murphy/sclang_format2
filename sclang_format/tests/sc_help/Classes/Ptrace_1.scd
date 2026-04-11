// Source: Classes/Ptrace.schelp block 1
(
// An event pattern playing random scale degrees
p = Pbind(\dur, 0.125, \degree, Pwhite(0,10));

// Se what the value of the scale degrees are using trace
Ptrace(p, \degree, prefix: "Current scale degree: ").play
)
