// Source: Classes/Ringz.schelp block 1
(
a = {
	// rectangular pulse exciter (deterministic input)
	var exc = EnvGen.ar(Env([1, 1, 0], [0.01, 0], \lin)),
	sig = Ringz.ar(exc, 440, decaytime: 0.2),
	rms = sqrt(Integrator.ar(sig.squared) * (0.2 / SampleRate.ir)),
	end = DetectSilence.ar(sig, doneAction: 2);
	rms.poll(end);
	Silent.ar(1)
}.play;
)
