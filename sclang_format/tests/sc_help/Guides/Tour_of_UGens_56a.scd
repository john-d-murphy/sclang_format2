// Source: Guides/Tour_of_UGens.schelp block 56 (part 1/2)
(
{
	var trig;
	trig = Impulse.kr(2.0);
	PlayBuf.ar(1,b,BufRateScale.kr(b),trig,0,0);
}.scope(1);
)
