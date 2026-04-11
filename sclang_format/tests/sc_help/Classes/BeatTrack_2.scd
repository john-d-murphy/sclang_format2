// Source: Classes/BeatTrack.schelp block 2
(
SynthDef(\help_beattrack2, { |out|
	var trackb, trackh, trackq, tempo;
	var source;
	var bsound, hsound, qsound;

	source = SoundIn.ar(0);

	#trackb, trackh, trackq, tempo = BeatTrack.kr(FFT(LocalBuf(1024)));

	bsound = Pan2.ar(LPF.ar(WhiteNoise.ar * Decay.kr(trackb, 0.05), 1000), 0.0);

	hsound = Pan2.ar(BPF.ar(WhiteNoise.ar * Decay.kr(trackh, 0.05), 3000, 0.66), -0.5);

	qsound = Pan2.ar(HPF.ar(WhiteNoise.ar * Decay.kr(trackq, 0.05),5000), 0.5);

	Out.ar(out, bsound + hsound + qsound);
}).play;
)
