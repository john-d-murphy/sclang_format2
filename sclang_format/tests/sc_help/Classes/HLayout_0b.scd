// Source: Classes/HLayout.schelp block 0 (part 2/5)
(
w = Window().front;
a = { { Button(w) } ! 10 } ! 10;
w.layout = HLayout(*a.collect { |x| VLayout(*x) });
)
