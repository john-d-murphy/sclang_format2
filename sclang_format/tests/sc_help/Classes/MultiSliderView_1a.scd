// Source: Classes/MultiSliderView.schelp block 1 (part 1/2)
(
var size;
size = 350 / 6;
w = Window.new;
w.view.decorator = FlowLayout(w.view.bounds);
m = MultiSliderView(w, Rect(0, 0, 350, 100));
m.value_(Array.fill(size, {0.01}));
m.isFilled_(true); // width in pixels of each stick
m.indexThumbSize_(2.0); // spacing on the value axis
m.gap_(4);
w.front;
)
