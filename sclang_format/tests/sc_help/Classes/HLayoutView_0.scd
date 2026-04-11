// Source: Classes/HLayoutView.schelp block 0
(
q = 10;
w = Window.new;

h = HLayoutView(w,Rect(0,0,300,300));

Array.fill(q,{ arg i;
    Slider(h,Rect(0,0,20,75)).value_(i / q)
});
h.background_(Color.rand);

w.front
)
