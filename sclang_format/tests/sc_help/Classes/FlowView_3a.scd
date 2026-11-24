// Source: Classes/FlowView.schelp block 3 (part 1/2)
(
w = GUI.window.new;
w.front;
f = FlowView.new(w);
f.background = Color.blue(alpha: 0.1);

GUI.slider.new(f, Rect(0, 0, 100, 100));
GUI.slider.new(f, Rect(0, 0, 100, 100));

f.used.postln;

// overlaid
GUI.compositeView.new(w, f.used)
	.background = Color.red(alpha: 0.1);
)
