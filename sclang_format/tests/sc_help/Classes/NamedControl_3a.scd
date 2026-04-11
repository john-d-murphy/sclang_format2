// Source: Classes/NamedControl.schelp block 3 (part 1/6)
(
a = {
    var x, y;
    x = NamedControl.kr(\freq, 440).lag(3.5);
    y = NamedControl.kr(\freq, 440).lag(1);
    SinOsc.ar([x, y] * [2, 1.2]) * 0.1
}.play;
)
