// Source: Classes/Pdef.schelp block 8 (part 3/5)
Pdef(\x, Pbind(\degree, Pseq((0..5), inf), \dur, 0.3)).condition_({ |val, i| i.postln % 6 == 0 });
