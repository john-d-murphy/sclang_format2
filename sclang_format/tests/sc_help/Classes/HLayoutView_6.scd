// Source: Classes/HLayoutView.schelp block 6
(
q = 10;
w = Window.new;

h = HLayoutView(w,Rect(0,0,300,300));
h.setProperty(\spacing,0);

Array.fill(q,{
    Slider(h,Rect(0,0,20,75))
});

w.front
)
