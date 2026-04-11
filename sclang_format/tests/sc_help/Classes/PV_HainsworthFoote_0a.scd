// Source: Classes/PV_HainsworthFoote.schelp block 0 (part 1/4)
(
SynthDef(\fftod, { |out|
	var source1, detect;
	source1 = SoundIn.ar(0);
	detect = PV_HainsworthFoote.ar(FFT(LocalBuf(2048),source1), 1.0, 0.0);
	Out.ar(out, SinOsc.ar([440, 445], 0, Decay.ar(0.1 * detect, 0.1)));
}).play(s);
)
