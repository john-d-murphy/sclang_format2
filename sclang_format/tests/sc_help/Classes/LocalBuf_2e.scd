// Source: Classes/LocalBuf.schelp block 2 (part 5/11)
(
{
	var buf1 = LocalBuf.newFrom((0..5).scramble);
	var buf2 = LocalBuf.newFrom((0..5).scramble - 1);
	var buf3 = LocalBuf.newFrom((0..5).scramble + 1);
	var index = DetectIndex.kr([buf1, buf2], SinOsc.kr([0.85, 0.8], 0, 6).trunc).poll;
	var freq = IndexL.kr([buf2, buf3], index).poll * 40 + 40;
	Saw.ar(freq) * 0.1
}.play;
)
