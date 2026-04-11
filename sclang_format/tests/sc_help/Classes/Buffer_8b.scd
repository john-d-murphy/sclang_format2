// Source: Classes/Buffer.schelp block 8 (part 2/4)
(
b = Buffer.loadDialog(s, action: { arg buffer;
	x = { PlayBuf.ar(buffer.numChannels, buffer, BufRateScale.kr(buffer)) }.play;
});
)
