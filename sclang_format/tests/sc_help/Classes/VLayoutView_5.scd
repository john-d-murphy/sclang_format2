// Source: Classes/VLayoutView.schelp block 5
(
q = 10;
w = Window.new;

v = VLayoutView(w,Rect(10,10,300,300));
v.setProperty(\spacing,0);

Array.fill(q,{
    Slider(v,Rect(0,0,75,20))
});

w.front
)
