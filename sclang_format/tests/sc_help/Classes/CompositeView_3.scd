// Source: Classes/CompositeView.schelp block 3
(
a = Window.new;
b = CompositeView(a, Rect(0, 0, 500, 500));

b.decorator = FlowLayout(Rect(0, 0, 500, 500));

Slider2D(b,Rect(0, 0, 100, 100)).background_(Color.rand);
CompositeView(b, Rect(0, 0, 70, 100)); // just used for spacing
Slider2D(b,Rect(0, 0, 100, 100)).background_(Color.rand);
Slider2D(b,Rect(0, 0, 100, 100)).background_(Color.rand);

b.decorator.nextLine;

Slider2D(b, Rect(0, 0, 100, 100)).background_(Color.rand);
Slider2D(b, Rect(0, 0, 100, 100)).background_(Color.rand);
CompositeView(b, Rect(0, 0, 70, 100)); // just used for spacing
Slider2D(b,Rect(0,0,100,100)).background_(Color.rand);

a.front;
)
