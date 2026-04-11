// Source: Classes/Demand.schelp block 2 (part 3/7)
(
{
	var freq, trig, reset, seq;
	trig = Impulse.kr(10);
	seq = Diwhite(60, 72, inf).midicps;
	freq = Demand.kr(trig, 0, seq);
	SinOsc.ar(freq + [0,0.7]).cubed.cubed * 0.1;
}.play;
)
