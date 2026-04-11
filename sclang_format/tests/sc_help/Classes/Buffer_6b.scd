// Source: Classes/Buffer.schelp block 6 (part 2/10)
(
a = FloatArray.fill(44100 * 5.0, {1.0.rand2}); // 5 seconds of noise
b = Buffer.loadCollection(s, a);
)
