// Source: Classes/VLayoutView.schelp block 4
(
q = 5;
w = Window.new;

v = VLayoutView(w,Rect(10,10,300,300));
v.resize = 5; // elastic
v.background_(Color.grey);
Array.fill(q,{ arg i;
    var s;
    s = Slider(v,Rect(0,0,75,20)).background_(Color.blue.alpha_(0.2));
    s.value = i / 5;
    s.resize = 5;
    s.setProperty(\minHeight,20);
    s.setProperty(\maxHeight,40);
    s
});
w.front
)
