// Source: Classes/HLayoutView.schelp block 3
(
q = 5;
w = Window.new;

h = HLayoutView(w,Rect(0,0,300,300));
h.background = Color.rand;
h.resize = 5; // elastic

Array.fill(q,{ arg i;
    var s;
    s = Slider(h,Rect(0,0,20,75));
    s.value = i / 5;
    if(i < 2,{
        s.resize = 5; // some elastic
        s.setProperty(\minWidth,20);
    },{
        s.resize = 1; // some not elastic
    });
    s
});
StaticText(h, Rect(0,0,105,20)).background_(Color.rand).string_(" Some Example\n Text");

w.front
)
