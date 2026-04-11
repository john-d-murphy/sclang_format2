// Source: Classes/VLayoutView.schelp block 0 (part 1/2)
(
q = 10;
w = Window.new;

v = VLayoutView(w,Rect(10,10,300,300));

Array.fill(q,{ arg i;
    Slider(v,Rect(0,0,75,20)).value_(i / q)
});

w.front
)
