// Source: Classes/NamedControl.schelp block 3 (part 4/6)
(
a = {
    var x, y;
    x = Control.names([\freq]).kr(440).lag(3.5);
    y = Control.names([\freq]).kr(440).lag(1); // this hangs when set
    SinOsc.ar([x, y] * [2, 1.2]) * 0.1
}.play;
)
