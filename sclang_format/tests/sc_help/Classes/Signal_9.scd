// Source: Classes/Signal.schelp block 9
(
a = Signal.newClear(256);
a.waveFill({ arg x, old, i; sin(x)}, 0, 3pi);
a.waveFill({ arg x, old, i; old * sin(11 * x + 0.3) }, 0, 3pi);
a.waveFill({ arg x, old, i; old * (x % 4) }, 0, 3pi);

a.plot;
)
