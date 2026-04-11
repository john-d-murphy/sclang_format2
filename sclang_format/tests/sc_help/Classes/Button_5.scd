// Source: Classes/Button.schelp block 5
(
s.waitForBoot({
	var w, p, snd, b;

	w = Window.new;

	b = Button(w, Rect(20, 20, 80, 26))
			.states_([["start a sound", Color.black, Color.green], ["stop", Color.black, Color.red]])
			.action_({});

	v = VLayoutView(w, Rect(140, 20, 200, 300)); //Group the following views
	StaticText(v, Rect(20, 20, 180, 60))
		.string_("The button does nothing at first, so try dragging a function to the button");

	DragSource(v, Rect(20, 20, 80, 26))
		.object_(
			{|b| (b.value == 1).if{ snd = { SinOsc.ar(440,0,0.6) }.play} { snd.free }; } //a button action function
			)
		.string_("a play sine function").align_(\center).background_(Color.rand);

	DragSource(v, Rect(20, 20, 80, 26))
		.object_(
			{|b| (b.value == 1).if{ snd = { Saw.ar(440,0.4) }.play} { snd.free }; } //a button action function
			)
		.string_("a play saw function").align_(\center).background_(Color.rand);

	DragSource(v, Rect(20, 20, 80, 26))
		.object_(
			{|b| (b.value == 1).if{ snd = { WhiteNoise.ar(0.4) }.play } { snd.free }; } //a button action function
			)
		.string_("a play noise function").align_(\center).background_(Color.rand);

	p = CmdPeriod.add({ b.value_(0) }); // set button to 0 on hitting Cmd-period
	w.onClose_{ snd.free; CmdPeriod.removeAll };//clean up when window is closed
	w.front;
})
)
