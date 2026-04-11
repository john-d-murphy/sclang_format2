// Source: Guides/Tour_of_UGens.schelp block 57 (part 1/5)
(
{
	var trig;
	trig = Impulse.kr(MouseY.kr(0.5,200,1));
	PlayBuf.ar(1,b,BufRateScale.kr(b),trig,MouseX.kr(0,BufFrames.kr(b)),1)
}.scope(1);
)
