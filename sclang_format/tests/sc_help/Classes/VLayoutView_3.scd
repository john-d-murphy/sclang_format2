// Source: Classes/VLayoutView.schelp block 3
(
q = 5;
w = Window.new;

v = VLayoutView(w,Rect(10,10,300,300));
v.resize = 5; // elastic
v.background_(Color.grey);
Array.fill(q,{ arg i;
    var s;
    s = Slider(v,Rect(0,0,75,20)).background_(Color.rand);
    s.value = i / 5;
    if(i < 2,{
        s.resize = 5; // some elastic
        s.setProperty(\minHeight,20);
    },{
        s.resize = 1; // some not elastic
    });
    s
});
StaticText(v, Rect(0,0,55,20)).background_(Color.rand).string_("Some Example Text").align_(\center);

w.front
)
