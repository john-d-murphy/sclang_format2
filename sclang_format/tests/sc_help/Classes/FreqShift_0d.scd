// Source: Classes/FreqShift.schelp block 0 (part 4/5)
(
b = Buffer.read(s, ExampleFiles.child);
{ FreqShift.ar(PlayBuf.ar(1, b.bufnum, BufRateScale.kr(b.bufnum), loop: 1), LFNoise0.kr(0.45, 1000), 0, [1, 1]) }.play(s);
)
