// Source: Classes/TDelay.schelp block 0
(
{
	z = Impulse.ar(2);
	[z * 0.1, ToggleFF.ar(TDelay.ar(z, 0.5)) * SinOsc.ar(mul: 0.1)]
}.scope)
