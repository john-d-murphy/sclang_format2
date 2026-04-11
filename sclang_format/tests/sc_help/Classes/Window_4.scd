// Source: Classes/Window.schelp block 4
(
w = Window(scroll: true); // you must set this when the window is created
c = Slider2D(w, Rect(0, 0, 1500, 300));
d = Slider(w, Rect(0, 310, 20, 300));
c.background = Color.grey.alpha = 0.6;
d.background = Color.grey.alpha = 0.6;
w.front;
)
