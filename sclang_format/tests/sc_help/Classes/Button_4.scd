// Source: Classes/Button.schelp block 4
(
s.waitForBoot({
	w = Window.new;
	b = Button(w, Rect(20, 20, 80, 26))
			.states_([["play", Color.black, Color.rand]])
			.mouseDownAction_({
				a = {EnvGen.kr(Env.adsr, doneAction: Done.freeSelf) * SinOsc.ar(440, 0, 0.4)}.play;
			})
			.action_({ arg butt, mod;
				a.release(0.3);
			});
	w.front;
})
)
