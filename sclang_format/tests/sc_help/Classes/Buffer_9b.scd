// Source: Classes/Buffer.schelp block 9 (part 2/4)
(
b = Buffer.loadChannelDialog(s, channels: [0], action: { arg buffer;
	x = { PlayBuf.ar(buffer.numChannels, buffer, BufRateScale.kr(buffer)) }.play;
});
)
