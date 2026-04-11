// Source: Guides/News-Qt-GUI.schelp block 5
(
var win, parent, child, sibling1, sibling2;
win = Window(bounds:Rect(30,30,300,300));
parent = Slider2D(win, win.bounds.moveTo(0,0).insetBy(50,50));

// A StaticText will propagate mouse clicks to parent by default:
child = StaticText(parent, Rect(100,-50,150,150))
    .align_(\bottomLeft)
    .string_("\npropagate\nto\nSlider2D")
    .background_(Color.red.alpha_(0.4));

// This StaticText is not a child of Slider2D so will propagate mouse
// clicks to the window instead:
sibling1 = StaticText(win, Rect(0,0,150,150))
    .align_(\topLeft)
    .string_("propagate\nto\nWindow")
    .background_(Color.cyan.alpha_(0.4));

// This StaticText is not a child of Slider2D, but is made transparent for mouse events:
sibling2 = StaticText(win, Rect(150,150,150,150))
    .align_(\bottomRight)
    .string_("ignore")
    .background_(Color.green.alpha_(0.4))
    .acceptsMouse_(false);
win.view.mouseDownAction = { win.background = Color.red(0.6) };
win.view.mouseUpAction = { win.view.palette = QPalette() };
win.front;
)
