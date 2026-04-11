// Source: Classes/Pdef.schelp block 8 (part 4/5)
Pdef(\x, Pbind(\degree, Pseq((0..7) + 5.rand, inf), \dur, 0.3)).condition_({ |val, i| (i % 8).postln == 0 });
