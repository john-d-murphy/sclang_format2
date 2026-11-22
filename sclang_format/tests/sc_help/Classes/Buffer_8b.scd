// Source: Classes/Buffer.schelp block 8 (part 2/4)
(
b = Buffer.loadDialog(s, action: { |buffer|
	x = { PlayBuf.ar(buffer.numChannels, buffer, BufRateScale.kr(buffer)) }.play;
});
)
