// Source: Classes/BinaryOpUGen.schelp block 4
(
{
    var a = SinOsc.ar(1).round(0.1);
    var b = SinOsc.ar(1.2).round(0.1);
    BinaryOpUGen('==', a, b) * 0.1
}.play;
)
