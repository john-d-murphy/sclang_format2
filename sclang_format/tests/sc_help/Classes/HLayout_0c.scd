// Source: Classes/HLayout.schelp block 0 (part 3/6)
(
w = Window().front;
a = { { Button(w) } ! 10 } ! 10;
w.layout = HLayout(*a.collect { |x| VLayout(*x) });
)
