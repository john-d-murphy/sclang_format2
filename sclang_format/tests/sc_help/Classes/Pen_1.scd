// Source: Classes/Pen.schelp block 1
(
w = Window.new.front;
w.view.background_(Color.white);
w.drawFunc = {
    Pen.translate(100, 100);
    10.do{
        // set the Color
        Pen.color = Color.red(rrand(0.0, 1), rrand(0.0, 0.5));
        Pen.addArc((100.rand)@(100.rand), rrand(10, 100), 2pi.rand, pi);
        Pen.perform([\stroke, \fill].choose);
    }
};
w.refresh;
)
