// Source: Classes/FreeSelfWhenDone.schelp block 0 (part 3/6)
(
{ var env, output;
env = Line.kr(0, 1, 1);
output = SinOsc.ar(200, 0, 0.5) * env;
output.postln; // output is a BinaryOpUGen, which has no 'done' flag
FreeSelfWhenDone.kr(output); // won't ever be done
output
}.play;
)
