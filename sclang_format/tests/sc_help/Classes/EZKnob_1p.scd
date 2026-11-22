// Source: Classes/EZKnob.schelp block 1 (part 16/20)
(
w = Window("EZKnob", Rect(380, 400, 300, 180)).front;
w.view.decorator = FlowLayout(w.view.bounds, gap: 1@1);
StaticText(w, (42 * 4 + 3) @ 16).string_("EZKnob Cluster").background_(Color.blue(0.1, 0.1));
w.view.decorator.nextLine;
a = [
		EZKnob(w, 42 @ 74, "knob 1", margin: 2@2, labelHeight: 16),
		EZKnob(w, 42 @ 74, "knob 2", controlSpec: \freq, margin: 2@2, labelHeight: 16),
		EZKnob(w, 42 @ 74, "knob 3", controlSpec: \pan, margin: 2@2, labelHeight: 16).round_(0.001),
		EZKnob(w, 42 @ 74, "knob 4", controlSpec: \rq, margin: 2@2, labelHeight: 16)
	];
a.do{ |a|a.view.background_(Color.grey.alpha_(0.4)) };
)
