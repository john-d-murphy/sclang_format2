// Source: Guides/Tour_of_UGens.schelp block 57 (part 2/5)
(
{
	var rate;
	rate = XLine.kr(0.1,100,60);
	PlayBuf.ar(1, b, rate, 1.0,0.0, 1.0)
}.scope(1);
)
