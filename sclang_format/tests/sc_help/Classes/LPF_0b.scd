// Source: Classes/LPF.schelp block 0 (part 2/3)
(
{ var ctl = LPF.kr(LFPulse.kr(8), SinOsc.kr(XLine.kr(1, 30, 5)) + 2);
	SinOsc.ar(ctl * 200 + 400)
}.play;
)
