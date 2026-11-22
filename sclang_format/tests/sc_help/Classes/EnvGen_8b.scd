// Source: Classes/EnvGen.schelp block 8 (part 2/2)
(
{
    EnvGen.kr(
        Env.asr(0.1, 1.0, 0.5, \welch),
        1.0,
        Rand(0.1, 1.0),
        timeScale: 0.1
    ) * SinOsc.ar(440, 0, 0.3)
}.play;
)
