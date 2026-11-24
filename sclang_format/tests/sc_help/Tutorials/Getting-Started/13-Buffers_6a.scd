// Source: Tutorials/Getting-Started/13-Buffers.schelp block 6 (part 1/3)
(
b = Buffer.read(s, ExampleFiles.child, action: { arg buffer;
	("numFrames after update:" + buffer.numFrames).postln;
	x = { PlayBuf.ar(1, buffer, BufRateScale.kr(buffer)) }.play;
});

// Note that the next line will execute BEFORE the action function
("numFrames before update:" + b.numFrames).postln;
)
