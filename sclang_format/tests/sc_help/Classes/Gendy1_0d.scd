// Source: Classes/Gendy1.schelp block 0 (part 4/18)
(
{
    var mx, my;

    mx = MouseX.kr(220, 440);
    my = MouseY.kr(0.0, 1.0);

    Pan2.ar(Gendy1.ar(2, 3, 1, 1, minfreq: mx, maxfreq: 8*mx, ampscale: my, durscale: my, initCPs: 7, mul: 0.3), 0.0)
}.play
)
