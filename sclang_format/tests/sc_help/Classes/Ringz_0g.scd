// Source: Classes/Ringz.schelp block 0 (part 7/7)
(
{
    var exciter;
    exciter = WhiteNoise.ar(0.001);
    Mix.arFill(10, {
        Ringz.ar(exciter,
        XLine.kr(exprand(100.0, 5000.0), exprand(100.0, 5000.0), 20),
        0.5)
    })
}.play
)
