// Source: Classes/Buffer.schelp block 18 (part 3/10)
(
b.loadCollection(v, action: {|buf|
	x = { PlayBuf.ar(buf.numChannels, buf, BufRateScale.kr(buf), loop: 1)
		* 0.2 }.play;
});
)
