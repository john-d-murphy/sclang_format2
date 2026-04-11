// Source: Classes/Slider.schelp block 5
(
s.waitForBoot({

	SynthDef(\pluck, { |out, freq=55|
		Out.ar(out,
			Pluck.ar(WhiteNoise.ar(0.06),
				EnvGen.kr(Env.perc(0,4), 1.0, doneAction: Done.freeSelf),
				freq.reciprocal,
				freq.reciprocal,
				10,
				coef:0.1)
		);
	}).add;


	w = Window.new("Hold arrow keys to trigger sound",
		Rect(300, Window.screenBounds.height - 300, 400, 100)).front;
	a = Slider(w, Rect(50, 20, 300, 40)).value_(0.5).step_(0.05).focus
	.action_({
		// trigger a synth with varying frequencies
		Synth(\pluck, [\freq, 55 + (1100 * a.value)]);
		w.view.background_(Gradient(Color.rand,Color.rand));
	})
});
)
