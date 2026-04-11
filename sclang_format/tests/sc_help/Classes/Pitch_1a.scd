// Source: Classes/Pitch.schelp block 1 (part 1/3)
(
		SynthDef("pitchFollow2", { |out|
			var in, amp, freq, hasFreq, sound;
			in = Mix.new(SoundIn.ar([0, 1]));
			amp = Amplitude.kr(in, 0.05, 0.05);
			# freq, hasFreq = Pitch.kr(in, ampThreshold: 0.02, median: 7);
			sound = CombC.ar(LPF.ar(in, 1000), 0.1, (2 * freq + 10).reciprocal, -6).distort * 0.05;
			6.do({
				sound = AllpassN.ar(sound, 0.040, [0.040.rand, 0.040.rand], 2)
			});
			Out.ar(out, sound);
		}).play(s);
	)
