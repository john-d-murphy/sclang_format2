// Source: Classes/LocalBuf.schelp block 2 (part 4/11)
(
{
	var buf = LocalBuf.newFrom((0..5).scramble);
	var freq = IndexL.kr(buf, MouseX.kr(0, BufFrames.kr(buf))).poll * 100 + 40;
	Saw.ar(freq * [1, 1.1]) * 0.1
}.play;
)
