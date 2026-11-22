// Source: Classes/Env.schelp block 4
(
{
    var trig = Trig.kr(1, 1.4); // gate opens for 1.4 sec
    var env = EnvGen.kr(
        Env(
            levels: [0.001, 1, 0.5, 0.9, 0.3, 0.7, 0],
            times:  [0.01, 0.05, 0.2,  0.15, 0.4, 0.1],
            curve:  [\exp,   5,  \sin, \exp, \lin, 0],
            releaseNode: 4, // loop at 0.3
            loopNode: 1 // cycle back to 0.5
        ), gate: trig
    );
    [trig, env]
}.plot(duration: 2)
)
