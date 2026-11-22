// Source: Classes/MoogFF.schelp block 0 (part 4/5)
(
x = {
    MoogFF.ar(
        Pulse.ar([40, 121], [0.3, 0.7]),
        SinOsc.kr(LFNoise0.kr(0.42).range(0.001, 2.2)).range(30, 4200),
        0.83 * 4) }.play(s);
)
