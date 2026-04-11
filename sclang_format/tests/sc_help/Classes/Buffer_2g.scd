// Source: Classes/Buffer.schelp block 2 (part 7/9)
(
b = Buffer.read(s, p, action: { arg buffer;
    ("After update:" + buffer.numFrames).postln;
    x = { PlayBuf.ar(1, buffer, BufRateScale.kr(buffer)) }.play;
});
("Before update:" + b.numFrames).postln;
)
