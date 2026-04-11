// Source: Tutorials/Getting-Started/13-Buffers.schelp block 10 (part 2/5)
(
// load the FloatArray into b, then play it
b.loadCollection(v, action: {|buf|
	x = { PlayBuf.ar(buf.numChannels, buf, BufRateScale.kr(buf), loop: 1)
		* 0.2 }.play;
});
)
