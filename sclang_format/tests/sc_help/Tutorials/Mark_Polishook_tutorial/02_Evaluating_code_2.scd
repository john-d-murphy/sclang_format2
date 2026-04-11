// Source: Tutorials/Mark_Polishook_tutorial/02_Evaluating_code.schelp block 2
(
{
	RLPF.ar(
		in: Saw.ar([100, 102], 0.15),
		freq: Lag.kr(LFNoise0.kr(4, 700, 1100), 0.1),
		rq: 0.05
	)
}.play
)
