// Source: Guides/NodeMessaging.schelp block 9
(
		SynthDef(\controlList, { |out = 0, freq = 440, amp = 0.1, detune = #[0.999, 1.001], gate = 1|
			var	sig = Mix(Saw.ar(freq * (detune ++ [1]), amp)),
			env = EnvGen.kr(Env.adsr, gate, doneAction: Done.freeSelf);
			Out.ar(out, (sig * env) ! 2);
		}).add;

		SynthDescLib.global[\controlList]
	)
