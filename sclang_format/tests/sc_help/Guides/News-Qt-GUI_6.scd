// Source: Guides/News-Qt-GUI.schelp block 6
(
var val = 1.0;
t=StaticText(bounds:Rect(30,30,100,100))
    .font_(Font(size:25))
    .align_(\center)
    .string_(val.asString)
    .stringColor_(Color.red)
    .background_(Color.black)
    .front;
t.mouseEnterAction = { t.background = Color.white };
t.mouseLeaveAction = { t.background = Color.black };
t.mouseWheelAction = { |v,x,y,mod,dx,dy|
    if(dy > 0) { val = val + 0.05 } { val = val - 0.05 };
    val = val.clip(0,2).round(0.01);
    t.string = val.asString;
    t.stringColor = Color.red(val);
};
)
