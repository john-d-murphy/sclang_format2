// Source: Guides/Tour_of_UGens.schelp block 57 (part 4/5)
(
{
	var rate;
	rate = LFNoise2.kr(XLine.kr(1,20,60), 2);
	PlayBuf.ar(1,b,BufRateScale.kr(b) * rate,1,0,1)
}.scope(1);
)
