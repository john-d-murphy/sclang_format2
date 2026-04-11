// Source: Classes/HLayout.schelp block 0 (part 4/5)
(
w = Window().front;
a = { HLayout(Slider(w, Rect(0, 0, 130, 20)), Button(w)) } ! 12;
b = { Slider2D(w) } ! 3;
w.layout = HLayout(VLayout(*a), VLayout(*b));
)
