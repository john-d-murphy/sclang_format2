// Source: Classes/FreeSelfWhenDone.schelp block 0 (part 2/6)
(
{ var env;
env = Line.kr(0, 1, 1);
FreeSelfWhenDone.kr(env); // free synth at end of line
SinOsc.ar(200, 0, 0.5) * env
}.play;
)
