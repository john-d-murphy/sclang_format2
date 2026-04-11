// Source: Classes/Buffer.schelp block 27 (part 2/4)
(
b = Buffer.alloc(s, 512, 1);
b.sine1(1.0 / [1, 2, 3, 4], true, true, true);
x = { Osc.ar(b, 200, 0, 0.5) }.play;
)
