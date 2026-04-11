// Source: Classes/BAllPass.schelp block 0 (part 4/5)
(
z = { // like a bandpass
	var sig;
	sig = SoundIn.ar([0,1]) * 0.5;
	BAllPass.ar(sig, MouseX.kr(10, 18000, \exponential), 0.8) + sig.neg
}.play)
