// Source: Classes/Impulse.schelp block 0
({
	var f = 1000;
	HPZ1.ar(HPZ1.ar(
		Phasor.ar(rate: f * SampleDur.ir)
	)) > 1e-5
}.plot(0.005))
