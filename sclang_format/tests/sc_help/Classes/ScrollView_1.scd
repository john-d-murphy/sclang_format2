// Source: Classes/ScrollView.schelp block 1
(
w = Window.new;

b = ScrollView(w, Rect(0, 0, 300, 300)).hasBorder_(true);
c = CompositeView(b, Rect(0, 0, 500, 500)); // 'canvas' is this big
c.decorator = FlowLayout(c.bounds); // now we can use a decorator

Slider2D(c, Rect(0, 0, 240, 240));
Slider2D(c, Rect(0, 0, 240, 240));
Slider2D(c, Rect(0, 0, 240, 240));

c.decorator.nextLine;
w.front;
)
