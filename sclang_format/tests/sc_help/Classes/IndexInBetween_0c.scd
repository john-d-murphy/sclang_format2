// Source: Classes/IndexInBetween.schelp block 0 (part 3/6)
(
{
	var index, f0, f1, f3;
	var buffer = [ 200, 210, 400, 430, 600, 800 ].as(LocalBuf);
	f0 = MouseX.kr(200, 900);
	index = IndexInBetween.kr(buffer, f0);
	f1 = IndexL.kr(buffer, index);
	SinOsc.ar([f0, f1]) * 0.1

}.play;
)
