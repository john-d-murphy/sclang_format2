// Source: Guides/Tour_of_UGens.schelp block 57 (part 3/5)
(
{
	var rate;
	rate = FSinOsc.kr(XLine.kr(0.2,8,30), 0, 3, 0.6);
	PlayBuf.ar(1,b,BufRateScale.kr(b)*rate,1,0,1)
}.scope(1);
)
