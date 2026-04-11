// Source: Classes/ZeroCrossing.schelp block 0 (part 2/2)
(
{
    var a;
    a = SinOsc.ar(SinOsc.kr(1, 0, 600,700), 0, 0.1);
    [a, ZeroCrossing.ar(a) * 0.0005]
}.scope;
)
