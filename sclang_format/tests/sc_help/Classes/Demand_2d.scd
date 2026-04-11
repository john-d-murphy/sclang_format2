// Source: Classes/Demand.schelp block 2 (part 4/7)
(
{
	var freq, trig, reset, seq;
	trig = Impulse.kr(10);
	seq = Dseq([72, 75, 79, Drand([82,84,86])], inf).midicps;
	freq = Demand.kr(trig, 0, seq);
	SinOsc.ar(freq + [0,0.7]).cubed.cubed * 0.1;
}.play;
)
