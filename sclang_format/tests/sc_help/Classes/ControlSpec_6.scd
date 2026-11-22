// Source: Classes/ControlSpec.schelp block 6
(
var w, c, d;
w = Window.new("control", Rect(128, 64, 340, 160));
w.front;
c = Slider.new(w, Rect(10, 10, 300, 30));
d = StaticText.new(w, Rect(10, 40, 300, 30));
c.action = {
	d.string = "unmapped value"
	+ c.value.round(0.01)
	+ "......"
	+ "mapped value"
	+ a.map(c.value)
};
)
