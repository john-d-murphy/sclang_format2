// Source: Classes/Pen.schelp block 9
(
w = Window.new.front;
w.drawFunc = {
    // fill the gradient
    Pen.addOval(w.view.bounds.insetBy(30));
    Pen.fillRadialGradient(w.view.bounds.center,
        w.view.bounds.center, 0, w.bounds.width, Color.rand, Color.rand);
};
w.refresh;
)
