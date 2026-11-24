// Source: Classes/LFGauss.schelp block 3 (part 9/9)
( // test spectrum
{
	var son = LeakDC.ar(LFGauss.ar(0.005, 0.2));
	BPF.ar(son * 3, MouseX.kr(60, 2000, 1), 0.05)
}.play
)
