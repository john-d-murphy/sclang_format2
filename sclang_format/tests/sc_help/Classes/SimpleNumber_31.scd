// Source: Classes/SimpleNumber.schelp block 31
(
var center = 0.5, ctlCenter;
w = Window("biexp", Rect(100, 100, 200, 100)).front;
a = Slider(w, Rect(20, 20, 150, 20)).value_(0.5);
b = Slider(w, Rect(20, 45, 150, 20)).value_(0.5);
b.action = { center = b.value };
a.mouseDownAction = { ctlCenter = a.value + 0.05 };
a.action = {
	b.value = (a.value + 0.1).biexp(ctlCenter, 0.1, 1.1, center, 0, 1);
};
)
