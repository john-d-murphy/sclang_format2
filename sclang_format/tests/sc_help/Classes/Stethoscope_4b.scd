// Source: Classes/Stethoscope.schelp block 4 (part 2/14)
(
{
    SinOsc.ar([225, 450, 900], 0, 0.2)
    + LPF.ar(
        LFPulse.ar(226 * [1, 2, 5], [0, 0.1, 0.1], 0.2, 0.2),
        MouseX.kr(20, 10000, 1)
        )
}.scope;
)
