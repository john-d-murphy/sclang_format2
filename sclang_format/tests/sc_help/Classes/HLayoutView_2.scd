// Source: Classes/HLayoutView.schelp block 2
(
q = 10;
w = Window.new;

h = HLayoutView(w,Rect(0,0,300,300));
h.resize = 5; // elastic
h.background = Color.rand;

Array.fill(q,{ arg i;
    var s;
    s = Slider(h,Rect(0,0,20,75));
    s.resize = 5; // elastic
    s.value = i / q;
    s
});
StaticText(h, Rect(0,0,105,20)).background_(Color.rand).string_(" Some Example\n Text");

w.front
)
