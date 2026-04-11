// Source: Guides/News-Qt-GUI.schelp block 11
(
var w, e, m;
e = EnvelopeView()
    .value_([[0,0.4,0.6,1.0],[0,0.7,0.5,0.56]])
    .strings_(["alpha", "beta", "gamma", "delta"])
    .thumbWidth_(60)
    .style_(\dots);
m = PopUpMenu()
    .items_(["Dot Style", "Rect Style"])
    .action_({e.style = m.value});
w = Window()
    .layout_(VLayout(m,e))
    .front;
)
