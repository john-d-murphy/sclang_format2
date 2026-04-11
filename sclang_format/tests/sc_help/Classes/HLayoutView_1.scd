// Source: Classes/HLayoutView.schelp block 1
(
q = 8;
w = Window.new;

h = HLayoutView(w,Rect(0,0,300,300));
h.background = Color.rand;
h.resize = 5; // elastic

Array.fill(q,{ arg i;
    var s;
    s = Slider(h,Rect(0,0,20,75)).background_(Color.grey.alpha_(0.4));
    s.value = i / q;
    s
});
StaticText(h, Rect(0,0,105,20)).background_(Color.rand).string_(" Some Example\n Text");
w.front
)
