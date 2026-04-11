// Source: Classes/PV_HainsworthFoote.schelp block 0 (part 2/4)
(
SynthDef(\fftod, { |out|
	var source1, detect;
	source1= LFSaw.ar(LFNoise0.kr(1, 90, 400), 0, 0.5);
	detect= PV_HainsworthFoote.ar(FFT(LocalBuf(2048), source1), 1.0, 0.0, 0.9, 0.5);
	Out.ar(out, Pan2.ar(source1, -1.0) + Pan2.ar(SinOsc.ar(440, 0, Decay.ar(0.1 * detect, 0.1)), 1.0));
}).play(s);
)
