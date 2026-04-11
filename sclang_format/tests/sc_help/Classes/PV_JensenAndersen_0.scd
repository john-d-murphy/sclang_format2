// Source: Classes/PV_JensenAndersen.schelp block 0
(
SynthDef(\fftod, { |out|
	var source1, detect, chain;
	source1 = SoundIn.ar(0);
	chain = FFT(LocalBuf(2048), source1);
	detect = PV_JensenAndersen.ar(chain, threshold:MouseX.kr(0.1, 1.0));
	Out.ar(out, SinOsc.ar([440, 445], 0, Decay.ar(0.1 * detect, 0.1)));
}).play(s);
)
