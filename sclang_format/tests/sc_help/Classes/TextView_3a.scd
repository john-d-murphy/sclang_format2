// Source: Classes/TextView.schelp block 3 (part 1/14)
(
w = Window.new("Text View Example", Rect(100, Window.screenBounds.height-400, 520, 300)).front;
t = TextView(w.asView, Rect(10, 10, 500, 200))
    .focus(true);
)
