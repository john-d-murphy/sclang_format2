// Source: Classes/Signal.schelp block 10
(
a = Signal.newClear(16);
a.waveFill({ arg x, prev, i; [x, prev, i].postln; sin(x).max(0) }, 0, 3pi);
a.plot;
)
