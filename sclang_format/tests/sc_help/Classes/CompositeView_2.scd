// Source: Classes/CompositeView.schelp block 2
(
a = Window.new;

b = CompositeView(a,Rect(0, 0, 500, 500));
b.decorator = FlowLayout(b.bounds);
//b.addFlowLayout; // you can also write this for convenience

// adding views to b automatically use the decorator
// no need to use parent.decorator.place
c = Slider2D(b,Rect(0, 0, 100, 100)); // size matters
d = Slider2D(b,Rect(0, 0, 100, 100)); // origin doesn't

a.front;
)
