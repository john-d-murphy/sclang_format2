// Source: Classes/HLayoutView.schelp block 5
(
q = 5;
w = Window.new;

h = HLayoutView(w,Rect(0,0,300,300));
h.resize = 5; // elastic

Array.fill(q,{ arg i;
    var s;
    s =     StaticText(h,120@20).string_("Some short text which wraps around");

    s.resize = 5;
    s.setProperty(\minWidth,10);
    s.setProperty(\maxWidth,120);

    // not working
    s.setProperty(\maxHeight,10);
    s.setProperty(\minHeight,10);

    s.background = Color.white;
    s
});

w.front
)
