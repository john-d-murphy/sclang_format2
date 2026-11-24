// Source: Classes/Env.schelp block 18 (part 4/4)
( // Multichannel expansion of levels
{ SinOsc.ar(EnvGen.kr(Env.circle(
    [0, 1, 0, 0.5 * (1..4), 0, 2.sqrt/2 * (1..4), 0],
    [0.01, 0.3]
)) * 440 + 200).clump(2).collect(_.sum) * 0.2
}.scope;
)
