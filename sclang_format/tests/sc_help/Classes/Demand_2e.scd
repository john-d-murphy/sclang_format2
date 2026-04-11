// Source: Classes/Demand.schelp block 2 (part 5/7)
(
{
	var freq, trig, reset, seq;
	trig = Impulse.kr(10);
	seq = Dswitch1(
		[
			Diwhite(60, 72, inf),
			Dseq([72, 75, 79, Drand([82,84,86])], inf)
		],
		LFPulse.kr(0.2)
	);
	freq = Demand.kr(trig, 0, seq.midicps);
	SinOsc.ar(freq + [0,0.7]).cubed.cubed * 0.1;
}.play;
)
