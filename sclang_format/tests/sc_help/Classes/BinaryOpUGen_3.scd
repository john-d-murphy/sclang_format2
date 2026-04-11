// Source: Classes/BinaryOpUGen.schelp block 3
(
{
    var trig;
    trig = SinOsc.ar(1) > 0.1;
    EnvGen.kr(Env.perc, trig, doneAction: Done.none) * SinOsc.ar(440,0,0.1)
}.play
)
