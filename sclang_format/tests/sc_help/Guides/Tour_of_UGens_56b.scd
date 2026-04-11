// Source: Guides/Tour_of_UGens.schelp block 56 (part 2/2)
(
{
	var trig;
	trig = Impulse.kr(XLine.kr(0.1,100,30));
	PlayBuf.ar(1,b,BufRateScale.kr(b),trig,5000,0);
}.scope(1);
)
