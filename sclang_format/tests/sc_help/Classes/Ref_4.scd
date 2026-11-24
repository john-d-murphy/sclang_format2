// Source: Classes/Ref.schelp block 4
(
	SynthDef(\multi, { |out, freq = #[100, 200, 300], amp = 0.1, pan = 0, sustain = 1|
		var audio, env;
		env = EnvGen.kr(Env.perc(0.01, sustain), doneAction: Done.freeSelf);
		audio = Mix(Saw.ar(freq));
		audio = Pan2.ar(audio * env, pan, amp);
		OffsetOut.ar(out, audio)
	}).add;

	(instrument: \multi, freq: [[500, 501, 700]], sustain: 2).play

)
