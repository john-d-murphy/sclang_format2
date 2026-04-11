// Source: Classes/LocalBuf.schelp block 2 (part 9/11)
(
{
	var buf = LocalBuf(2048, 2).clear;
	BufWr.ar(WhiteNoise.ar(1.dup), buf, LFNoise0.ar(530).range(0, BufFrames.kr(buf)));
	PlayBuf.ar(2, buf, MouseX.kr(1, 2), loop: 1) * 0.1
}.play
)
