// Source: Classes/NumberBox.schelp block 0 (part 1/12)
(
    w = Window("NumberBox Example", Rect(100, 500, 400, 120));
    b =     NumberBox(w, Rect(150, 10, 100, 20));
    b.value = rrand(1,15);
    b.action = {arg numb; numb.value.postln; };
    w.front
)
