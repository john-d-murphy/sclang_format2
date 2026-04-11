// Source: Classes/Ramp.schelp block 2 (part 3/3)
(
var pulse;
{
	pulse = LFPulse.kr(8.772);
	Out.kr(0,[Ramp.kr(pulse, 0.025), Lag.kr(pulse, 0.025), pulse]);
}.play;
s.scope(3, bufsize: 44100, rate: \control, zoom: 40);
)
