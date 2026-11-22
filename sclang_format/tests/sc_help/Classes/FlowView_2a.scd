// Source: Classes/FlowView.schelp block 2 (part 1/3)
(
f = FlowView.new;

GUI.slider.new(f, Rect(0, 0, 100, 100));
GUI.slider.new(f, Rect(0, 0, 100, 100));

GUI.slider.new(f, f.indentedRemaining)
	.background = Color.blue(alpha: 0.2)
)
