// Source: Classes/EnvGen.schelp block 7 (part 1/2)
(
{
    EnvGen.kr(
        Env.new([ 0.001, 1, 0.5, 0 ], [ 0.01, 0.3, 1 ], -4, 2, nil),
        Impulse.kr(10)
    ) * SinOsc.ar(440, 0, 0.1)
}.play;
)
