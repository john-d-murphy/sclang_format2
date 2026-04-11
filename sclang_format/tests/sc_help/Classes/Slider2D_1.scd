// Source: Classes/Slider2D.schelp block 1
(
w = Window("Slider2D", Rect(100, 100, 500, 300));
w.view.decorator = FlowLayout(w.view.bounds);
t = Slider2D(w, Rect(20, 20, 280, 280))
		.x_(0.5) // initial location of x
		.y_(1)   // initial location of y
		.background_(Color.rand)
		.action_({|sl|
			[\sliderX, sl.x, \sliderY, sl.y].postln;
		});
t.step_(0.01);

n = CompositeView.new(w, 200@300);
n.decorator = FlowLayout(n.bounds);

v = { |i| DragBoth.new(n, Rect(0, i * 20, 200, 20)).background_(Color.rand).align_(\center) }.dup(5);

StaticText.new(n, 200@150).string_("hold down cmd and drag points from the slider to the drag slots, or reverse").stringColor_(Color.white);

w.front;
)
