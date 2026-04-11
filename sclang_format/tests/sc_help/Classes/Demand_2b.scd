// Source: Classes/Demand.schelp block 2 (part 2/7)
(
{
	var trig, seq, freq;
	trig = Impulse.kr(12);
	seq = Drand([Dseq((1..5).mirror1, 1), Drand((4..10), 8)], 2000) * Drand([1,2,4,8],2000);
	freq = Demand.kr(trig, 0, seq * 100);
	SinOsc.ar(freq + [0,0.7]).cubed.cubed.scaleneg(MouseX.kr(-1,1)) * 0.1;
}.play;
)
