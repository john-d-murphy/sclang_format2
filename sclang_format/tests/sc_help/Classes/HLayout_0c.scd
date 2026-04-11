// Source: Classes/HLayout.schelp block 0 (part 3/5)
(
w = Window().front;
a = { { PopUpMenu(w, Rect(0, 0, 50, 20)).items_({"abcdefghijklmno".scramble.keep(3)} ! 7) } ! 10 } ! 10;
w.layout = HLayout(*a.collect { |x| VLayout(*x) });
)
