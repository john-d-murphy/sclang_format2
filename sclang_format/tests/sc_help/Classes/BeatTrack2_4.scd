// Source: Classes/BeatTrack2.schelp block 4
(
SynthDef(\help_beattrack2_2, { |out|
	var trackb, trackh, trackq, tempo;
	var source, kbus;
	var bsound, hsound, qsound;

	source = SoundIn.ar(0);

	// downsampling automatic via kr from ar
	kbus = Out.kr(0, LPF.ar(source, 1000)); // ([feature1, feature3]++feature2);

	#trackb, trackh, trackq, tempo = BeatTrack2.kr(0, 1, weightingscheme: e.bufnum);

	bsound = Pan2.ar(LPF.ar(WhiteNoise.ar * (Decay.kr(trackb, 0.05)), 1000), 0.0);
	hsound = Pan2.ar(BPF.ar(WhiteNoise.ar * (Decay.kr(trackh, 0.05)), 3000, 0.66), -0.5);
	qsound = Pan2.ar(HPF.ar(WhiteNoise.ar * (Decay.kr(trackq, 0.05)), 5000), 0.5);

	Out.ar(out, source + bsound + hsound + qsound);
}).play;
)
