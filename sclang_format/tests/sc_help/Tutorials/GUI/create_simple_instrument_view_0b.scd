// Source: Tutorials/GUI/create_simple_instrument_view.schelp block 0 (part 2/2)
(
SynthDef(\instrView, { |out = 0, amp = 0.25, freq = 440, dur = 1.0|
	var snd, env;

	env = EnvGen.kr(Env.perc(dur * 0.01, dur * 0.99), doneAction: Done.freeSelf);
	snd = SinOsc.ar(freq, mul: amp);
	snd = snd * env;
	snd = snd!2;

	Out.ar(out, snd);
}).add;
)
