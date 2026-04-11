// Source: Tutorials/Getting-Started/13-Buffers.schelp block 10 (part 1/5)
(
// make some white noise
v = FloatArray.fill(44100, {1.0.rand2});
b = Buffer.alloc(s, 44100);
)
