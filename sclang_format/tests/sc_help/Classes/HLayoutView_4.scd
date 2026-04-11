// Source: Classes/HLayoutView.schelp block 4
(
q = 5;
w = Window.new;

h = HLayoutView(w,Rect(0,0,300,300));
h.resize = 5; // elastic
h.background = Color.rand;
Array.fill(q,{ arg i;
    var s;
    s = Slider(h,Rect(0,0,20,75));
    s.value = i / 5;
    s.resize = 5;
    s.setProperty(\minWidth,20);
    s.setProperty(\maxWidth,40);
    s
});

w.front
)
