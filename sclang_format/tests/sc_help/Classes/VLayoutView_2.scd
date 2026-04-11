// Source: Classes/VLayoutView.schelp block 2
(
q = 10;
w = Window.new;

v = VLayoutView(w,Rect(10,10,300,300));
v.background_(Color.rand);
v.resize = 5; // elastic
Array.fill(q,{ arg i;
    var s;
    s = Slider(v,Rect(0,0,75,20));
    s.resize = 5; // elastic
    s.value = i / q;
    s
});
StaticText(v, Rect(0,0,55,40))
    .background_(Color.rand).string_("Some Example Text")
    .align_(\center);

w.front
)
