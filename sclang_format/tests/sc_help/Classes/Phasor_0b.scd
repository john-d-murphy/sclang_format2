// Source: Classes/Phasor.schelp block 0 (part 2/7)
(
{
	var trig = Impulse.kr(ControlRate.ir/5);
	var ramp = Phasor.kr(trig, 1, start: 0, end: 10, resetPos: 7);
	[ramp, trig * 10]
}.plot(0.03).plotMode_([\dlines, \dstems])
)
