// Source: Classes/Pitch.schelp block 1 (part 2/3)
(
		SynthDef(\RmOctaver, { |out|
			var in, freq, hasFreq;
			in = SoundIn.ar(0);
			# freq, hasFreq = Pitch.kr(in);
			Out.ar(out, SinOsc.ar(freq: freq * 0.5) * in + in);
		}).add;
	)
