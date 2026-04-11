// Source: Classes/Buffer.schelp block 18 (part 7/10)
(
b.loadCollection(m, 0, {|buf|
	x = { PlayBuf.ar(2, buf, BufRateScale.kr(buf), loop: 1) * 0.5 }.play;
});
)
