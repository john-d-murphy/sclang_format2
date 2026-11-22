// Source: Classes/TempoBusClock.schelp block 0 (part 1/14)
(
a = { |tempo = 1| Ringz.ar(Impulse.ar(tempo), [501, 500], 1/tempo) }.play;
t = TempoBusClock(a);
Task { loop { "klink".postln; 1.wait } }.play(t);
);
