// Source: Classes/LeakDC.schelp block 0
(
{
	var a;
	a = LFPulse.ar(800, 0.5, 0.5, 0.5);
	[a, LeakDC.ar(a, 0.995)]
}.scope(bufsize: 22050)
)
