// Source: Classes/VLayoutView.schelp block 6
(
q = 10;
w = Window.new("nesting",Rect(30,30,400,700));

v = VLayoutView(w,Rect(10,10,300,600));

v.background = Color.rand;

Array.fill(q,{ arg i;
    Slider(v,Rect(0,0,75,20)).value_(i / q)
});

StaticText(v, Rect(0,0,55,20)).background_(Color.rand).string_("Some Example Text").align_(\center);

h = HLayoutView(v,Rect(10,10,300,300));

Array.fill(q,{ arg i;
    Slider(h,Rect(0,0,20,70)).value_(i / q)
});
h.background = Color.rand;

w.front
)
