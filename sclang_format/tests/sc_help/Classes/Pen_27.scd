// Source: Classes/Pen.schelp block 27
(
w = Window.new("Transparency Layer test", Rect(400,400,430,450)).front;
w.drawFunc = {
    Color.blue.setStroke;

    Pen.use {
    Pen.setShadow(2@2, 10, Color.black);
    Pen.beginTransparencyLayer;

    Color.red.setFill;
    Pen.addOval(Rect(20,40,100,100));
    Pen.fill;

    Color.green.setFill;
    Pen.addOval(Rect(30,70,100,100));
    Pen.fill;

    Color.blue.setFill;
    Pen.addOval(Rect(60,40,100,100));
    Pen.fill;

    "With Transparency Layer".drawCenteredIn(Rect(30, 40, 100, 100), Font.default, Color.white);
    Pen.endTransparencyLayer;
    };

    Pen.use {
    Pen.translate(200, 0);
    Pen.setShadow(2@2, 10, Color.black);


    Color.red.setFill;
    Pen.addOval(Rect(20,40,100,100));
    Pen.fill;

    Color.green.setFill;
    Pen.addOval(Rect(30,70,100,100));
    Pen.fill;

    Color.blue.setFill;
    Pen.addOval(Rect(60,40,100,100));
    Pen.fill;

    "Without Transparency Layer".drawCenteredIn(Rect(30, 40, 100, 100), Font.default, Color.white);
    };

    Pen.use {
        Pen.translate(0, 200);
        Pen.setShadow(2@2, 10, Color.black);
        Pen.beginTransparencyLayer;

        Pen.push;
        Pen.addOval(Rect(20,40,170,170));
        Pen.fillAxialGradient(w.view.bounds.leftTop, w.view.bounds.rightBottom, Color.rand, Color.rand);
        Pen.pop;

        "With Transparency Layer".drawCenteredIn(Rect(20,40,170,170), Font.default, Color.white);

        Pen.endTransparencyLayer;
    };

    Pen.use {
        Pen.translate(200, 200);
        Pen.setShadow(2@2, 10, Color.black);
        Pen.addOval(Rect(20,40,170,170));
        Pen.fillAxialGradient(w.view.bounds.leftTop, w.view.bounds.rightBottom, Color.rand, Color.rand);

        "Without Transparency Layer".drawCenteredIn(Rect(20,40,170,170), Font.default, Color.white);
    };
};
w.refresh;
)
