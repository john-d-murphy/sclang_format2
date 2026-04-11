// Source: Classes/Buffer.schelp block 28 (part 2/4)
(
b = Buffer.alloc(s, 512, 1);
b.sine2([1.0, 3], [1, 0.5]);
x = { Osc.ar(b, 200, 0, 0.5) }.play;
)
