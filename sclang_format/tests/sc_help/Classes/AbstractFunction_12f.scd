// Source: Classes/AbstractFunction.schelp block 12 (part 6/6)
{ a = LFNoise1.ar(1) * 5 + 60; Pulse.ar(a.round.midicps) * 0.1 }.play;
