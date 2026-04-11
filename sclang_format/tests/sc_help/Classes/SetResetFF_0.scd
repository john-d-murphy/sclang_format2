// Source: Classes/SetResetFF.schelp block 0
(
play({
	a = Dust.ar(5); // the set trigger
	b = Dust.ar(5); // the reset trigger
	SetResetFF.ar(a,b) * BrownNoise.ar(0.2);

}))
